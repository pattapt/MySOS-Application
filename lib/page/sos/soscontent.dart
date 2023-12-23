import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:slide_action/slide_action.dart';
import 'package:url_launcher/url_launcher.dart';

class SOSContent extends StatefulWidget {
  const SOSContent({super.key});
  @override
  State<SOSContent> createState() => _SOSContentState();
}

class _SOSContentState extends State<SOSContent> with TickerProviderStateMixin {
  bool isHelp = false;
  int countdown = 5;
  Timer? countdownTimer;

  void updateIsHelp(bool newValue) {
    setState(() {
      isHelp = newValue;
    });
    if(newValue == true) startCountdown();
  }


  void startCountdown() {
    countdown = 5;
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) async{
      if (countdown > 0) {
        setState(() {
          countdown--;
        });
        if(countdown == 5){

          // final audioCache = AudioCache();
          // audioCache.play('assets/sound/sos.mp3');
          // AudioPlayer player = AudioPlayer();

          // String audioasset = "assets/sound/sos-sound.mp3";
          // ByteData bytes = await rootBundle.load(audioasset); //load sound from assets
          // Uint8List  soundbytes = bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
          // int result = await player.playBytes(soundbytes);

        }
        if(countdown == 0){ 
          _callNumber("191");
          updateIsHelp(false);
        }
      } else {
        timer.cancel();
      }
    });
  }

  void cancelCountdown() {
    setState(() {
      countdown = 0;
      isHelp = false;
    });
  }

  void _callNumber(number) async{
    launchUrl(Uri.parse('tel:$number'));

    await FlutterPhoneDirectCaller.callNumber(number);
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.red,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              const Text(
                "SOS ฉุกเฉิน",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32, color: Colors.white)
              ),
              const Spacer(),
              if (isHelp == true) Container(
                width: 150,
                height: 150,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Center(
                  child: Text(
                    countdown.toString(),
                    style: TextStyle(
                      color: countdown <= 3 ? Colors.red : Colors.black,
                      fontSize: 72,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              if (isHelp == true) const Text(
                "เราจะโทรหาบริการฉุกเฉิน เมื่อสิ้นสุดการนับถอยหลัง",
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              if (isHelp == true) const Spacer(),
              if (isHelp == true) Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                child: TextButton(
                  onPressed: cancelCountdown,
                  child: const Icon(
                    Icons.clear,
                    color: Colors.grey,
                  ),
                ),
              ),
              if (isHelp == false) SlideAction(
                trackBuilder: (context, state) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        // Show loading if async operation is being performed
                        state.isPerformingAction ? "กำลังขอความช่วยเหลือ" : "เลื่อนเพื่อขอความช่วยเหลือ",
                      ),
                    ),
                  );
                },
                thumbBuilder: (context, state) {
                  return Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 0, 0),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      // Show loading indicator if async operation is being performed
                      child: state.isPerformingAction
                          ? const CupertinoActivityIndicator(
                              color: Colors.white,
                            )
                          : const Icon(
                              Icons.chevron_right,
                              color: Colors.white,
                            ),
                    ),
                  );
                },
                action: () async {
                  // Async operation
                  await Future.delayed(
                    const Duration(seconds: 1),
                    () => updateIsHelp(true),
                  );
                },
              ),
              const Spacer(),
              // const Text(
              //   "เมื่อคุณกดขอความช่วยเหลือ โทรศัพท์ของคุณจะส่งเสียงดัง",
              //   style: TextStyle(color: Colors.white),
              //   textAlign: TextAlign.center,
              // ),
            ],
          ),
        ),
      ),
    );


  }
}
