import 'package:flutter/material.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:a4s/data/view/user_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:a4s/myPage/reset_password.dart';

class Edit extends ConsumerStatefulWidget {
  const Edit({super.key});

  @override
  _EditState createState() => _EditState();
}

class AdaptiveTextSize {
  const AdaptiveTextSize();
  getadaptiveTextSize(BuildContext context, dynamic value) {
    // 720 is medium screen height
    return (value / 720) * MediaQuery.of(context).size.height;
  }
}

class _EditState extends ConsumerState<Edit> {
  TextStyle style = const TextStyle(fontSize: 18.0);
  late TextEditingController _name;
  late TextEditingController _password;
  late TextEditingController _new_password;
  late TextEditingController _confirm_new_password;
  late TextEditingController _email;
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();

  FocusNode searchFocusNode = FocusNode();
  FocusNode textFieldFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    final readUser = ref.read(userViewModelProvider);
    _name = TextEditingController(text: readUser.user!.name);

    _password = TextEditingController(text: "");
    _new_password = TextEditingController(text: "");
    _confirm_new_password = TextEditingController(text: "");
    _email = TextEditingController(
        text: readUser.user?.name != null ? readUser.user?.email : "");
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _new_password.dispose();
    _confirm_new_password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userViewModelProvider);
    return Scaffold(
        key: _key,
        appBar: AppBar(),
        body: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text('회원정보 수정',
                    style: TextStyle(
                        fontSize: const AdaptiveTextSize()
                            .getadaptiveTextSize(context, 13),
                        fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 10),
              user.user!.email == null || user.user?.email == ""
                  ? const SizedBox()
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 30),
                      child: TextFormField(
                        controller: _email,
                        validator: (value) =>
                            (value!.isEmpty) ? "이메일을 입력 해 주세요" : null,
                        style: style,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.email),
                          labelText: "이메일 변경",
                          filled: true,
                          fillColor: const Color(0xffF6F6F6),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30),
                child: TextFormField(
                  controller: _name,
                  validator: (value) =>
                      (value!.isEmpty) ? "닉네임 입력 해 주세요" : null,
                  style: style,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person),
                    labelText: "닉네임 변경",
                    filled: true,
                    fillColor: const Color(0xffF6F6F6),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30),
                child: OutlinedButton(
                    onPressed: () {
                      user
                          .sendPasswordResetEmail(
                              email: user.user!.email.toString())
                          .then((value) =>
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('비밀번호 재설정 메일을 전송합니다')),
                              ));
                    },
                    child: const Text(' 비밀번호 재설정하기')),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(40, 20, 40, 0),
                child: ElevatedButton(
                  onPressed: () {
                    user.updateUserInfo(
                        uid: user.user!.uid!,
                        email: _email.value.text,
                        name: _name.value.text);
                    showDialog(
                      context: context,
                      barrierDismissible: true, //바깥 영역 터치시 닫을지 여부 결정
                      builder: ((context) {
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          surfaceTintColor: Colors.white,
                          title: const Text("회원정보 수정"),
                          content: const Text("회원 정보가 수정되었습니다."),
                          actions: <Widget>[
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop(); //창 닫기
                              },
                              child: const Text("X"),
                            )
                          ],
                        );
                      }),
                    );
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromRGBO(33, 58, 135, 1))),
                  child: const Text(
                    "DONE",
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
