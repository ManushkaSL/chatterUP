import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chatter_up/services/chat/call_service.dart';
import 'dart:ui';

class CallScreen extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;
  final String callType; // 'audio' or 'video'
  final bool isIncoming;
  final String? incomingCallRoomID;

  const CallScreen({
    Key? key,
    required this.receiverEmail,
    required this.receiverID,
    required this.callType,
    this.isIncoming = false,
    this.incomingCallRoomID,
  }) : super(key: key);

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> with TickerProviderStateMixin {
  final CallService _callService = CallService();
  late String _callRoomID;
  bool _isMuted = false;
  bool _isVideoOn = true;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  int _callDuration = 0;

  @override
  void initState() {
    super.initState();

    if (widget.isIncoming) {
      _callRoomID = widget.incomingCallRoomID ?? '';
    } else {
      _callRoomID = '${widget.receiverID}_call';
      _initiateCall();
    }

    // Pulse animation for incoming call
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Start call duration timer if call is accepted
    _startCallTimer();
  }

  void _startCallTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _callDuration++;
        });
        _startCallTimer();
      }
    });
  }

  Future<void> _initiateCall() async {
    try {
      await _callService.initiateCall(
        widget.receiverID,
        widget.receiverEmail,
        widget.callType,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to initiate call: $e')));
    }
  }

  Future<void> _acceptCall() async {
    try {
      await _callService.acceptCall(_callRoomID);
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to accept call: $e')));
    }
  }

  Future<void> _rejectCall() async {
    try {
      await _callService.rejectCall(_callRoomID);
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to reject call: $e')));
    }
  }

  Future<void> _endCall() async {
    try {
      await _callService.endCall(_callRoomID);
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to end call: $e')));
    }
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: _callService.getCallStream(_callRoomID),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final callData = snapshot.data!.data() as Map<String, dynamic>?;
        if (callData == null) {
          return const Scaffold(
            body: Center(child: Text('Call data not found')),
          );
        }

        final status = callData['status'] ?? 'ringing';
        final isAccepted = status == 'accepted';

        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF000000), Color(0xFF1A1A1A)],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(height: 100),

                  // Caller/Receiver info
                  Column(
                    children: [
                      // Avatar with pulse effect for incoming calls
                      if (!isAccepted)
                        ScaleTransition(
                          scale: _pulseAnimation,
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [Color(0xFFFFFFFF), Color(0xFFE0E0E0)],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.3),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Icon(
                                widget.callType == 'video'
                                    ? Icons.videocam
                                    : Icons.phone,
                                size: 60,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        )
                      else
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [Color(0xFFFFFFFF), Color(0xFFE0E0E0)],
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              widget.callType == 'video'
                                  ? Icons.videocam
                                  : Icons.phone,
                              size: 60,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      const SizedBox(height: 24),

                      // Name
                      Text(
                        widget.receiverEmail,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Call status or duration
                      if (!isAccepted)
                        Text(
                          widget.isIncoming ? 'Incoming call...' : 'Calling...',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        )
                      else
                        Text(
                          _formatDuration(_callDuration),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                    ],
                  ),

                  // Call controls - only show if call is accepted
                  if (isAccepted)
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Mute button
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isMuted = !_isMuted;
                              });
                            },
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _isMuted
                                    ? Colors.red[700]
                                    : Colors.grey[700],
                              ),
                              child: Center(
                                child: Icon(
                                  _isMuted ? Icons.mic_off : Icons.mic,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                            ),
                          ),

                          // Video toggle (only for video calls)
                          if (widget.callType == 'video')
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isVideoOn = !_isVideoOn;
                                });
                              },
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _isVideoOn
                                      ? Colors.grey[700]
                                      : Theme.of(context).colorScheme.secondary,
                                ),
                                child: Center(
                                  child: Icon(
                                    _isVideoOn
                                        ? Icons.videocam
                                        : Icons.videocam_off,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                              ),
                            ),

                          // End call button
                          GestureDetector(
                            onTap: _endCall,
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red,
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.call_end,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  // Incoming call controls
                  else if (widget.isIncoming)
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Reject
                          GestureDetector(
                            onTap: _rejectCall,
                            child: Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.red.withOpacity(0.5),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.call_end,
                                  color: Colors.white,
                                  size: 32,
                                ),
                              ),
                            ),
                          ),

                          // Accept
                          GestureDetector(
                            onTap: _acceptCall,
                            child: Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.5),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.call,
                                  color: Colors.black,
                                  size: 32,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
