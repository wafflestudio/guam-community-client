import 'package:flutter/material.dart';
import 'package:guam_community_client/styles/colors.dart';
import 'package:provider/provider.dart';

import '../../../models/projects/project.dart';
import '../../../providers/recruit/recruit.dart';
import '../../../providers/user_auth/authenticate.dart';

class ProjectPreviewSquare extends StatelessWidget {
  final int idx;
  final Project project;
  final Function refreshProject;

  ProjectPreviewSquare({required this.idx, required this.project, required this.refreshProject});

  @override
  Widget build(BuildContext context) {
    Recruit recruitProvider = context.read<Recruit>();
    Authenticate authProvider = context.read<Authenticate>();

    Future<Project?> _getProject(int? id) {
      return Future.delayed(Duration(seconds: 0), () async {
        Project? _post = await recruitProvider.getProject(id);
        return _post;
      });
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        margin: const EdgeInsets.only(right: 15),
        width: 96,
        height: 96,
        child: InkWell(
            onTap: () {
              // 프로젝트 상세 페이지 이동 Future Builder??
            },
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                // 이미지에 음영 추가 해야 함
                SizedBox(
                  width: 96,
                  height: 96,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image(
                      image: NetworkImage(project.thumbnail!),
                      fit: BoxFit.cover,
                      color: GuamColorFamily.grayscaleGray5,
                      colorBlendMode: BlendMode.darken,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    project.title!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: GuamColorFamily.grayscaleWhite,
                    ),
                  ),
                ),
              ],
            )
        ),
      ),
    );
  }
}