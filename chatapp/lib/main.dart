import 'package:chatapp/Business/Repositories/AuthRepositories.dart';
import 'package:chatapp/Business/Repositories/BusinessSendFriendRequest.dart';
import 'package:chatapp/Business/Repositories/FriendListRepoBusiness.dart';
import 'package:chatapp/Business/Repositories/ProfileRepository.dart';
import 'package:chatapp/Business/Repositories/UserProfileRepositories.dart';
import 'package:chatapp/Business/Repositories/UserSearchRepositories.dart';
import 'package:chatapp/Business/Usecases/FriendListUseCase.dart';
import 'package:chatapp/Business/Usecases/ProfilePictureUsecase.dart';
import 'package:chatapp/Business/Usecases/SendFriendRequestUseCase.dart';
import 'package:chatapp/Business/Usecases/UserProfileUseCase.dart';
import 'package:chatapp/Business/Usecases/UserSearchUseCase.dart';
import 'package:chatapp/Data/DataSources/AuthApiService.dart';
import 'package:chatapp/Data/DataSources/HomePageApiService.dart';
import 'package:chatapp/Data/DataSources/ProfilePicture.dart';
import 'package:chatapp/Data/DataSources/UserProfileApiService.dart';
import 'package:chatapp/Data/Respositories/SendFriendRequest.dart';
import 'package:chatapp/Presentation/Pages/AuthPages/LoginPage.dart';
import 'package:chatapp/Presentation/Pages/Screens/HomePage.dart';
import 'package:chatapp/Presentation/StateManagement/FriendList/bloc/friend_list_bloc.dart';
import 'package:chatapp/Presentation/StateManagement/ProfilePictureBloc/bloc/profile_picture_bloc.dart';
import 'package:chatapp/Presentation/StateManagement/SendFriendRequest/bloc/send_friend_request_bloc.dart';
import 'package:chatapp/Presentation/StateManagement/UserProfile/bloc/user_profile_bloc.dart';
import 'package:chatapp/Presentation/StateManagement/UserSearch/bloc/user_search_bloc.dart';
import 'package:chatapp/Presentation/StateManagement/bloc/AuthBloc/auth_bloc.dart';
import 'package:chatapp/Routes/Routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authApiService = AuthApiService();
  bool loggedIn=await authApiService.isLoggedIn();
  final AuthRepository authRepository = AuthRepositoryImpl(AuthApiService());
  
  runApp(MultiBlocProvider(providers: [
    BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(authRepository),
    ),
    BlocProvider(
        create: (context) => ProfilePictureBloc(ProfilePictureUseCase(
            profileRepository:
                ProfileUploadRepositoryImpl(ProfilePictureService())))),
    BlocProvider<UserSearchBloc>(
        create: (context) => UserSearchBloc(UserSearchUseCase(
            userSearchRepositories: UsersearchrepositoriesImpl(
                homePageApiService: HomePageApiService())))),
    BlocProvider(
        create: (context) => SendFriendRequestBloc(
            sendFriendRequestUseCase: SendFriendRequestUseCase(
                sendFriendRequestRepositories:
                    BusinessSendFriendRequestRepositoriesImpl(
                        homePageApiService: HomePageApiService())),
            userSearchBloc: UserSearchBloc(UserSearchUseCase(
                userSearchRepositories: UsersearchrepositoriesImpl(
                    homePageApiService: HomePageApiService()))))),

                BlocProvider(create:(context) => FriendListBloc(FriendListUseCase(friendListRepoBusiness: FriendListRepoBusinessImpl(homePageApiService: HomePageApiService())))..add(ShowFriendList())),
                BlocProvider(create: (_)=>UserProfileBloc(userProfileUsecase: UserProfileUsecase(userProfileRepositories: UserProfileRepositoriesImpl(userProfileApiService: UserProfileApiService())),
                ProfilePictureUseCase(profileRepository: ProfileGetRepositoryImpl(ProfilePictureService()),
                ),
                
                ))
  ], child:  MyApp(loggedIn: loggedIn,)));
}

class MyApp extends StatefulWidget {
  final bool loggedIn;
  const MyApp({super.key, required this.loggedIn});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: widget.loggedIn?HomePageScreen():LoginPage(),
      initialRoute: "/",
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
