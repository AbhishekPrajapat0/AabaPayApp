/* Tushar Ugale * Technicul.com */
import 'package:aabapay_app/screens/home/home.dart';
import 'package:aabapay_app/screens/profile/kyc/aadhar/aadhar.dart';
import 'package:aabapay_app/screens/profile/kyc/pan/pan.dart';
import 'package:aabapay_app/screens/profile/kyc/photo/photo.dart';
import 'package:flutter/material.dart';
import 'package:aabapay_app/constants/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aabapay_app/screens/profile/kyc/bloc/kyc_bloc.dart';
import 'package:aabapay_app/screens/profile/kyc/bloc/kyc_state.dart';
import 'package:aabapay_app/screens/profile/kyc/bloc/kyc_event.dart';

class Kyc extends StatefulWidget {
  @override
  _KycState createState() => _KycState();
}

class _KycState extends State<Kyc> {
  final KycBloc _kycBloc = KycBloc();
  String aadharStatus = '';
  String aadharName = '';
  String aadharNumber = '';
  String aadharPhoto1 = '';
  String aadharPhoto2 = '';

  String panStatus = '';
  String panName = '';
  String panNumber = '';
  String panPhoto1 = '';
  String panPhoto2 = '';

  String photoStatus = '';
  String photoPhoto1 = '';
  String photoPhoto2 = '';

  @override
  void initState() {
    _kycBloc.add(KycLoadEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackBackgroundColor,
      appBar: AppBar(
        backgroundColor: blackBackgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => Home(
                      selectedIndex: 3,
                      profileUpdatedFlag: false,
                      feedbackAddedFlag: false)),
              (Route<dynamic> route) => false),
        ),
        title: const Text("KYC",
            style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Colors.white,
                fontSize: 20)),
      ),
      body: Container(
        margin: EdgeInsets.all(5.0),
        child: BlocProvider(
          create: (_) => _kycBloc,
          child: BlocListener<KycBloc, KycState>(
            listener: (context, state) {},
            child: BlocBuilder<KycBloc, KycState>(
              builder: (context, state) {
                if (state is KycLoadedState) {
                  for (var kyc in state.kycs) {
                    if (kyc.type == 'AADHAR' && kyc.status == 'VERIFIED') {
                      aadharStatus = 'VERIFIED';
                      aadharName = kyc.name;
                      aadharNumber = kyc.number;
                      aadharPhoto1 = kyc.photo1;
                      aadharPhoto2 = kyc.photo2;
                    }
                    if (aadharStatus == 'VERIFIED' &&
                        kyc.type == 'PAN' &&
                        kyc.status == 'VERIFIED') {
                      panStatus = 'VERIFIED';
                      panName = kyc.name;
                      panNumber = kyc.number;
                      panPhoto1 = kyc.photo1;
                      panPhoto2 = kyc.photo2;
                    }
                    if (aadharStatus == 'VERIFIED' &&
                        kyc.type == 'PHOTO' &&
                        kyc.status == 'VERIFIED') {
                      photoStatus = 'VERIFIED';
                      photoPhoto1 = kyc.photo1;
                      photoPhoto2 = kyc.photo2;
                    }
                  }
                }
                if (state is KycInitialState || state is KycLoadingState) {
                  return _buildLoading();
                } else {
                  return _buildHome(context, state);
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHome(BuildContext context, KycState state) {
    return SingleChildScrollView(
      child: SafeArea(
          bottom: true,
          top: true,
          child: Column(children: [
            profile(),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  aadhar(),
                  const SizedBox(height: 20),
                  selfie(),
                  const SizedBox(height: 20),
                  pan(),
                ],
              ),
            ),
          ])),
    );
  }

  Widget profile() {
    int percentage = 0;
    if (aadharStatus == 'VERIFIED') {
      percentage = percentage + 50;
    }
    if (panStatus == 'VERIFIED') {
      percentage = percentage + 25;
    }
    if (photoStatus == 'VERIFIED') {
      percentage = percentage + 25;
    }

    if (percentage == 75) {
      return Container(
          color: cardBackgroundColor,
          child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                        flex: 2,
                        child: Text(
                          'KYC Status',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        )),
                    Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '$percentage%',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ),
                          ),
                        )),
                  ])));
    } else {
      return Container(
          color: cardBackgroundColor,
          child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                        flex: 2,
                        child: Text(
                          'KYC Status',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        )),
                    Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            color: (percentage == 100 && percentage != 75
                                ? Colors.green
                                : Colors.red),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '$percentage%',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ),
                          ),
                        )),
                  ])));
    }
  }

  Widget aadhar() {
    return GestureDetector(
        onTap: () {
          if (aadharStatus == '') {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Aadhar(
                      skipKyc: false,
                    )));
          }
        },
        child: Column(
          children: [
            Container(
              color: cardHeaderBackgroundColor,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    const Expanded(
                      flex: 4,
                      child: Text("Aadhar Card",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w400)),
                    ),
                    Expanded(
                        flex: 3,
                        child: (aadharStatus == 'VERIFIED'
                            ? const Align(
                                alignment: Alignment.topRight,
                                child: Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                ),
                              )
                            : const Align(
                                alignment: Alignment.center,
                                child: Text("Not Verified",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    )),
                              ))),
                    (aadharStatus != 'VERIFIED'
                        ? const Expanded(
                            flex: 1,
                            child: Align(
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                                color: Colors.white,
                              ),
                            ))
                        : const Text(''))
                  ],
                ),
              ),
            ),
            Container(
              color: cardBackgroundColor,
              child: Column(
                children: [
                  (aadharStatus == 'VERIFIED'
                      ? Column(
                          children: [
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 8.0, top: 5),
                                    child: Text("Name : " + aadharName,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400)),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 8.0, top: 5),
                                    child: Text(
                                        "Aadhar Number : " + aadharNumber,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400)),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(flex: 1, child: Text('')),
                                Expanded(
                                  flex: 4,
                                  child: (aadharPhoto1 != ''
                                      ? Image.network(
                                          aadharPhoto1,
                                        )
                                      : Text('')),
                                ),
                                Expanded(flex: 1, child: Text('')),
                                Expanded(
                                  flex: 4,
                                  child: (aadharPhoto2 != ''
                                      ? Image.network(
                                          aadharPhoto2,
                                        )
                                      : Text('')),
                                ),
                                Expanded(flex: 1, child: Text('')),
                              ],
                            )
                          ],
                        )
                      : Column(
                          children: [
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(flex: 1, child: Text('')),
                                Expanded(
                                    flex: 7,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.asset(
                                        'assets/images/aadhar_front.png',
                                      ),
                                    )),
                                Expanded(flex: 1, child: Text('')),
                                Expanded(
                                    flex: 7,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.asset(
                                        'assets/images/aadhar_back.png',
                                      ),
                                    )),
                                Expanded(flex: 1, child: Text('')),
                              ],
                            )
                          ],
                        )),
                  heightAndDivider()
                ],
              ),
            ),
          ],
        ));
  }

  Widget pan() {
    return GestureDetector(
        onTap: () {
          if (aadharStatus == 'VERIFIED' && panStatus == '') {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => Pan()));
          }
        },
        child: Column(
          children: [
            Container(
              color: cardHeaderBackgroundColor,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    const Expanded(
                      flex: 4,
                      child: Text("Pan Card",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w400)),
                    ),
                    Expanded(
                        flex: 3,
                        child: (panStatus == 'VERIFIED'
                            ? const Align(
                                alignment: Alignment.topRight,
                                child: Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                ),
                              )
                            : const Align(
                                alignment: Alignment.center,
                                child: Text("Not Verified",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    )),
                              ))),
                    (aadharStatus == 'VERIFIED' && panStatus != 'VERIFIED'
                        ? const Expanded(
                            flex: 1,
                            child: Align(
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                                color: Colors.white,
                              ),
                            ))
                        : const Text(''))
                  ],
                ),
              ),
            ),
            Container(
              color: cardBackgroundColor,
              child: Column(
                children: [
                  (panStatus == 'VERIFIED'
                      ? Column(
                          children: [
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 8.0, top: 5),
                                    child: Text("Name : " + panName,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400)),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 8.0, top: 5),
                                    child: Text("Pan Number : " + panNumber,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400)),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(flex: 1, child: Text('')),
                                Expanded(
                                  flex: 4,
                                  child: (panPhoto1 != ''
                                      ? Image.network(
                                          panPhoto1,
                                        )
                                      : Text('')),
                                ),
                                Expanded(flex: 1, child: Text('')),
                                Expanded(
                                  flex: 4,
                                  child: (panPhoto2 != ''
                                      ? Image.network(
                                          panPhoto2,
                                        )
                                      : Text('')),
                                ),
                                Expanded(flex: 1, child: Text('')),
                              ],
                            )
                          ],
                        )
                      : Column(
                          children: [
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(flex: 1, child: Text('')),
                                Expanded(
                                  flex: 7,
                                  child: Image.asset(
                                    'assets/images/pan.png',
                                  ),
                                ),
                                Expanded(flex: 9, child: Text('')),
                              ],
                            )
                          ],
                        )),
                  heightAndDivider()
                ],
              ),
            ),
          ],
        ));
  }

  Widget selfie() {
    return GestureDetector(
        onTap: () {
          if (aadharStatus == 'VERIFIED' && photoStatus == '') {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => Photo()));
          }
        },
        child: Column(
          children: [
            Container(
              color: cardHeaderBackgroundColor,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    const Expanded(
                      flex: 4,
                      child: Text("Photo Verification",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w400)),
                    ),
                    Expanded(
                        flex: 3,
                        child: (photoStatus == 'VERIFIED'
                            ? const Align(
                                alignment: Alignment.topRight,
                                child: Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                ),
                              )
                            : const Align(
                                alignment: Alignment.center,
                                child: Text("Not Verified",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    )),
                              ))),
                    (aadharStatus == 'VERIFIED' && photoStatus == ''
                        ? const Expanded(
                            flex: 1,
                            child: Align(
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                                color: Colors.white,
                              ),
                            ))
                        : const Text(''))
                  ],
                ),
              ),
            ),
            Container(
              color: cardBackgroundColor,
              child: Column(
                children: [
                  (photoStatus == 'VERIFIED'
                      ? Column(
                          children: [
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(flex: 1, child: Text('')),
                                Expanded(
                                  flex: 4,
                                  child: (photoPhoto1 != ''
                                      ? Image.network(
                                          photoPhoto1,
                                        )
                                      : Text('')),
                                ),
                                Expanded(flex: 1, child: Text('')),
                                Expanded(
                                  flex: 4,
                                  child: (photoPhoto2 != ''
                                      ? Image.network(
                                          photoPhoto2,
                                        )
                                      : Text('')),
                                ),
                                Expanded(flex: 1, child: Text('')),
                              ],
                            )
                          ],
                        )
                      : Column(
                          children: [
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(flex: 1, child: Text('')),
                                Expanded(
                                  flex: 7,
                                  child: Image.asset(
                                    'assets/images/selfie3.png',
                                  ),
                                ),
                                Expanded(flex: 9, child: Text('')),
                              ],
                            )
                          ],
                        )),
                  heightAndDivider()
                ],
              ),
            ),
          ],
        ));
  }

//   Widget selfie() {
//     return GestureDetector(
//       onTap: () {
//         if (aadharStatus == 'VERIFIED' &&
//             panStatus == 'VERIFIED' &&
//             photoStatus != 'VERIFIED') {
//           Navigator.of(context)
//               .push(MaterialPageRoute(builder: (context) => Photo()));
//         }
//       },
//       child: Container(
//         color: cardBackgroundColor,
//         child: InkWell(
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Expanded(
//                     flex: 5,
//                     child: Padding(
//                       padding: EdgeInsets.only(left: 30.0, top: 30),
//                       child: Text("Photo Verification",
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 22,
//                               fontWeight: FontWeight.w400)),
//                     ),
//                   ),
//                   Expanded(
//                       flex: 3,
//                       child: (photoStatus == 'VERIFIED'
//                           ? const Padding(
//                               padding: EdgeInsets.only(right: 10.0, top: 5),
//                               child: Align(
//                                 alignment: Alignment.topRight,
//                                 child: Icon(
//                                   Icons.check_circle,
//                                   color: Colors.green,
//                                 ),
//                               ),
//                             )
//                           : const Padding(
//                               padding: EdgeInsets.only(right: 10.0, top: 5),
//                               child: Align(
//                                 alignment: Alignment.topRight,
//                                 child: Text("Not Verified",
//                                     style: TextStyle(
//                                       color: Colors.red,
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.w400,
//                                     )),
//                               ),
//                             ))),
//                   (aadharStatus == 'VERIFIED' &&
//                           panStatus == 'VERIFIED' &&
//                           photoStatus != 'VERIFIED'
//                       ? const Expanded(
//                           flex: 1,
//                           child: Align(
//                             alignment: Alignment.centerRight,
//                             child: Icon(
//                               Icons.arrow_forward_ios,
//                               size: 20,
//                               color: Colors.white,
//                             ),
//                           ))
//                       : const Text('')),
//                 ],
//               ),
//               (photoStatus == 'VERIFIED'
//                   ? Column(
//                       children: [
//                         SizedBox(height: 10),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Expanded(flex: 1, child: Text('')),
//                             Expanded(
//                               flex: 4,
//                               child: (photoPhoto1 != ''
//                                   ? Image.network(
//                                       photoPhoto1,
//                                     )
//                                   : Text('')),
//                             ),
//                             Expanded(flex: 1, child: Text('')),
//                             Expanded(
//                               flex: 4,
//                               child: (photoPhoto2 != ''
//                                   ? Image.network(
//                                       photoPhoto2,
//                                     )
//                                   : Text('')),
//                             ),
//                             Expanded(flex: 1, child: Text('')),
//                           ],
//                         )
//                       ],
//                     )
//                   : Column(
//                       children: [
//                         SizedBox(height: 20),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Expanded(flex: 1, child: Text('')),
//                             Expanded(
//                               flex: 7,
//                               child: Image.asset(
//                                 'assets/images/selfie3.png',
//                               ),
//                             ),
//                             Expanded(flex: 9, child: Text('')),
//                           ],
//                         )
//                       ],
//                     )),
//               heightAndDivider()
//             ],
//           ),
//         ),
//       ),
//     );
//   }

  Widget heightAndDivider() {
    return Column(
      children: const [
        SizedBox(height: 20),
        // Divider(color: Color.fromARGB(119, 245, 245, 245), thickness: 0.5),
        // SizedBox(height: 7),
      ],
    );
  }

  Widget _buildLoading() => Center(child: CircularProgressIndicator());
}
