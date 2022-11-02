import 'package:delivery/services/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AccountCard extends StatelessWidget {
  const AccountCard(
      {Key? key,
      required this.name,
      required this.phone,
      required this.onTap,
      required this.email})
      : super(key: key);

  final String name;
  final String email;
  final String phone;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 100,
      // decoration: BoxDecoration(boxShadow: shadow),
      margin: const EdgeInsets.fromLTRB(15, 15, 15, 10),
      child: Material(
        borderRadius: radius,
        // color: Theme.of(context).cardColor,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(borderRadius: radius),
            child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  Text(
                    name,
                    style: accentFont.copyWith(
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                      fontSize: 20,
                      color: Colors.grey[400],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    phone,
                    style: accentFont.copyWith(
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                      fontSize: 18,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    email,
                    style: accentFont.copyWith(
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                      fontSize: 18,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
