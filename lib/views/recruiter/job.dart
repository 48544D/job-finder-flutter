import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_finder/controllers/recruiter/appliants_controller.dart';
import 'package:job_finder/models/jobs.dart';
import 'package:job_finder/models/user.dart';
import 'package:job_finder/utils/background.dart';

class AppliantsPage extends StatefulWidget {
  const AppliantsPage({Key? key}) : super(key: key);

  @override
  AppliantsPageState createState() => AppliantsPageState();
}

class AppliantsPageState extends State<AppliantsPage> {
  final appliantsController = Get.put(AppliantsController());
  final jobId = Get.arguments.toString();
  late Widget currentTab = pendingAppliants();
  List tabsNames = ['Pending', 'Accepted'];
  int selected = 0;

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            'Appliants',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                icon: const Icon(
                  Icons.edit_note,
                  size: 30,
                ),
                color: Colors.white,
                onPressed: () {
                  Get.toNamed('/recruiter/edit-job', arguments: jobId);
                },
              ),
            )
          ],
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: MediaQuery.sizeOf(context).width,
              decoration: const BoxDecoration(
                color: Colors.deepPurple,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 5,
                    color: Color(0x32171717),
                    offset: Offset(0, 2),
                  )
                ],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                  topLeft: Radius.circular(0),
                  topRight: Radius.circular(0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
                child: StreamBuilder(
                    stream: appliantsController.getJob(jobId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        final job = snapshot.data as JobModel;
                        return topSection(job);
                      }
                    }),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  SizedBox(
                    height: 60,
                    child: Center(
                      child: ListView.builder(
                        itemCount: 2,
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemBuilder: (ctx, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selected = index;
                                if (index == 0) {
                                  currentTab = pendingAppliants();
                                } else {
                                  currentTab = acceptedAppliants();
                                }
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 100,
                                decoration: BoxDecoration(
                                  color: selected == index
                                      ? Colors.deepPurple
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Center(
                                  child: Text(
                                    tabsNames[index],
                                    style: TextStyle(
                                      color: selected == index
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 16.0, left: 16.0, right: 16.0),
                      child: currentTab,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  StreamBuilder pendingAppliants() {
    return StreamBuilder(
        stream: appliantsController.getAppliants(jobId).asBroadcastStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (!snapshot.hasData) {
              return const Center(
                child: Text('No appliants yet',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                    )),
              );
            }

            List appliants = snapshot.data as List;
            return ListView(
              children: [
                for (var i = 0; i < appliants.length; i++)
                  appliantCard(context, appliants[i], false),
              ],
            );
          }
        });
  }

  StreamBuilder acceptedAppliants() {
    return StreamBuilder(
        stream: appliantsController.getAcceptedAppliants(jobId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (!snapshot.hasData) {
              return const Center(
                child: Text('You haven\'t accepted any appliants yet',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                    )),
              );
            }

            List appliants = snapshot.data as List;
            return ListView(
              children: [
                for (var i = 0; i < appliants.length; i++)
                  appliantCard(context, appliants[i], true),
              ],
            );
          }
        });
  }

  Column topSection(JobModel job) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                  child: Text(
                    job.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 33,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${job.salary} DH',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(20, 8, 20, 0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text(
                'Date posted: ',
                textAlign: TextAlign.end,
                style: TextStyle(
                  color: Color(0xB3FFFFFF),
                  fontSize: 14,
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              Text(
                job.date.toString().substring(0, 10),
                textAlign: TextAlign.end,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Padding appliantCard(
      BuildContext context, UserModel appliant, bool isAccepted) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
      child: Container(
        width: MediaQuery.sizeOf(context).width * 0.92,
        height: 84,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              blurRadius: 3,
              color: Color(0x35000000),
              offset: Offset(0, 1),
            )
          ],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                child: Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      appliant.profilePicture,
                      width: 65,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${appliant.firstName} ${appliant.lastName}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                        child: Text(
                          appliant.email,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // accept appliant icon
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 8, 0),
                child: !isAccepted
                    ? confirmAppliantButton(appliant)
                    : unconfirmAppliantButton(appliant),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconButton confirmAppliantButton(UserModel appliant) {
    return IconButton(
      onPressed: () async {
        await appliantsController.confirmAppliant(jobId, appliant.id);
        setState(() {});
      },
      icon: CircleAvatar(
        backgroundColor: Colors.grey.shade200,
        child: const Icon(
          Icons.check,
          color: Colors.green,
          size: 30,
        ),
      ),
      iconSize: 30,
    );
  }

  IconButton unconfirmAppliantButton(UserModel appliant) {
    return IconButton(
      onPressed: () async {
        await appliantsController.unconfirmAppliant(jobId, appliant.id);
        setState(() {});
      },
      icon: CircleAvatar(
        backgroundColor: Colors.grey.shade200,
        child: const Icon(
          Icons.close,
          color: Colors.red,
          size: 30,
        ),
      ),
      iconSize: 30,
    );
  }
}
