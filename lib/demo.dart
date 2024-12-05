    import 'dart:developer';
    import 'package:flutter/material.dart';
    import 'package:signin_with_linkedin/signin_with_linkedin.dart';

    class SignInWithLinkedInPage extends StatefulWidget {
      const SignInWithLinkedInPage({super.key});

      @override
      State<SignInWithLinkedInPage> createState() => _SignInWithLinkedInPageState();
    }

    class _SignInWithLinkedInPageState extends State<SignInWithLinkedInPage> {
      final _linkedInConfig = LinkedInConfig(
        clientId: '864jl3dc01smkf',
        clientSecret: 'WPL_AP1.EZtmamGVVTNEdWOt.NksrwA==',
        redirectUrl: 'http://localhost:3000/auth/linkedin/callback',
        scope: ['openid', 'profile', 'email'],
      );
      LinkedInUser? _linkedInUser;

      void _showError(String error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      }

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Sign In'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    SignInWithLinkedIn.signIn(
                      context,
                      config: _linkedInConfig,
                      onGetUserProfile: (tokenData, user) {
                        log('Auth token data: ${tokenData.toJson()}');
                        log('LinkedIn User: ${user.toJson()}');
                        setState(() => _linkedInUser = user);
                      },
                      onSignInError: (error) {
                        log('Error on sign in: $error');
                        _showError(error.toString());
                      },
                    );
                  },
                  child: const Text('Sign in with LinkedIn'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    SignInWithLinkedIn.signIn(
                      context,
                      config: _linkedInConfig,
                      onGetAuthToken: (data) {
                        log('Auth token data: ${data.toJson()}');
                      },
                      onSignInError: (error) {
                        log('Error on sign in: $error');
                        _showError(error.toString());
                      },
                    );
                  },
                  child: const Text('Get Auth token from LinkedIn'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    await SignInWithLinkedIn.logout();
                    setState(() => _linkedInUser = null);
                  },
                  child: const Text('Logout'),
                ),
                const SizedBox(height: 16),
                if (_linkedInUser != null)
                  Column(
                    children: [
                      if (_linkedInUser!.picture != null)
                        Image.network(_linkedInUser!.picture!, width: 100),
                      const SizedBox(height: 10),
                      Text(_linkedInUser!.name ?? ''),
                      Text(_linkedInUser!.email ?? ''),
                    ],
                  ),
              ],
            ),
          ),
        );
      }
    }