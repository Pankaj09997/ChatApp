from django.shortcuts import render
from django.shortcuts import render
from rest_framework import status
from rest_framework.views import APIView
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework.response import Response
from django.contrib.auth import authenticate
from rest_framework.permissions import IsAuthenticated
from rest_framework import generics
from django.shortcuts import get_object_or_404
from api.serializers import UserRegistrationSerializers,UserLoginSerializers,UserProfileSerializers,ChangePasswordSerializer,ProfilePictureSerializer
from django.http import JsonResponse
from api.models import ProfilePicture,MyUser,Friendship,MyChats
from django.db.models import Q
from django.db.utils import IntegrityError

def get_token_for_user(user):
    refresh = RefreshToken.for_user(user)
    return {
        'refresh': str(refresh),
        'access': str(refresh.access_token)
    }
    
class UserRegistrationView(APIView):
    
    def post(self, request):
        serializer = UserRegistrationSerializers(data=request.data)
        if serializer.is_valid(raise_exception=True):
            user = serializer.save()
            token = get_token_for_user(user)
            return Response({"Token": token, 'msg': 'Registration Successful'}, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class UserLoginView(APIView):
    def post(self, request):
        serializers = UserLoginSerializers(data=request.data)
        if serializers.is_valid(raise_exception=True):
            email = serializers.validated_data.get('email')
            password = serializers.validated_data.get('password')
            user = authenticate(email=email, password=password)
            if user is not None:
                token = get_token_for_user(user)
                return Response({"Token": token, 'msg': 'Login Success'}, status=status.HTTP_200_OK)
            else:
                return Response({'msg': 'Invalid email or password'}, status=status.HTTP_400_BAD_REQUEST)
class UserProfileView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        serializers = UserProfileSerializers(request.user)
        return Response(serializers.data, status=status.HTTP_200_OK)

class UserChangePasswordView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        serializer = ChangePasswordSerializer(data=request.data, context={'user': request.user})
        if serializer.is_valid(raise_exception=True):
            return Response({'msg': 'Password Successfully changed'}, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
class ProfilePictureView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        """
        Retrieve the profile picture of the logged-in user.
        """
        try:
            profile_picture = ProfilePicture.objects.get(user=request.user)
            serializer = ProfilePictureSerializer(profile_picture)
            return Response(serializer.data, status=status.HTTP_200_OK)
        except ProfilePicture.DoesNotExist:
            return Response({'detail': 'Profile picture does not exist.'}, status=status.HTTP_404_NOT_FOUND)

    def post(self, request):
        print(request.user)
        """
        Upload a new profile picture for the logged-in user.
        """
        # Check if a profile picture already exists
        if ProfilePicture.objects.filter(user=request.user).exists():
            return Response({'detail': 'You already have a profile picture.'}, status=status.HTTP_409_CONFLICT)

        # Create a new profile picture
        serializer = ProfilePictureSerializer(data=request.data, context={"request": request})
        if serializer.is_valid(raise_exception=True):
            serializer.save(user=request.user)
            
            return Response({"detail": "Profile picture uploaded successfully."}, status=status.HTTP_201_CREATED)

    def patch(self, request):
        """
        Update the profile picture for the logged-in user.
        """
        try:
            profile_picture = ProfilePicture.objects.get(user=request.user)
            serializer = ProfilePictureSerializer(profile_picture, data=request.data, partial=True, context={"request": request})
            if serializer.is_valid():
                serializer.save()
                return Response(serializer.data, status=status.HTTP_200_OK)
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        except ProfilePicture.DoesNotExist:
            return Response({"detail": "Profile picture not found."}, status=status.HTTP_404_NOT_FOUND)

    def delete(self, request):
        """
        Delete the profile picture of the logged-in user.
        """
        try:
            profile_picture = ProfilePicture.objects.get(user=request.user)
            profile_picture.delete()
            return Response({"detail": "Profile picture has been deleted successfully."}, status=status.HTTP_204_NO_CONTENT)
        except ProfilePicture.DoesNotExist:
            return Response({"detail": "Profile picture not found."}, status=status.HTTP_404_NOT_FOUND)
        
class UserSearchView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, *args, **kwargs):
        query = request.GET.get('q', '').strip()
        if query:
            users = MyUser.objects.filter(Q(email__icontains=query)).exclude(id=request.user.id)
            results = []

            for user in users:
                # Check if the user and the logged-in user are friends
                is_friend = Friendship.objects.filter(
                    sender=request.user, receiver=user, is_accepted=True
                ).exists() or Friendship.objects.filter(
                    sender=user, receiver=request.user, is_accepted=True
                ).exists()

                # Check if the logged-in user has sent a friend request to this user
                friend_request_sent = Friendship.objects.filter(
                    sender=request.user, receiver=user, is_accepted=False
                ).exists()

                # Check if the logged-in user has received a friend request from this user
                friend_request_received = Friendship.objects.filter(
                    sender=user, receiver=request.user, is_accepted=False
                ).exists()

                # Append the relationship data to the results
                results.append({
                    "id": user.id,
                    "email": user.email,
                    "name": user.name,  # Ensure the MyUser model has a 'name' field
                    "is_friend": is_friend,
                    "friend_request_sent": friend_request_sent,
                    "friend_request_received": friend_request_received,
                })

            # Return after processing all users
            return Response(results, status=status.HTTP_200_OK)

        return Response({"msg": "Please enter a valid query."}, status=status.HTTP_400_BAD_REQUEST)


        
class SendFriendRequestsView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request, *args, **kwargs):
        receiver_id = request.data.get('receiver_id')
        if not receiver_id:
            return Response({"error": "Receiver ID is required"}, status=status.HTTP_400_BAD_REQUEST)

        try:
            receiver_user = MyUser.objects.get(id=receiver_id)

            # Prevent sending a friend request to oneself
            if receiver_user == request.user:
                return Response(
                    {"error": "You cannot send a friend request to yourself"},
                    status=status.HTTP_400_BAD_REQUEST,
                )

            # Check if a friendship request already exists
            if Friendship.objects.filter(sender=request.user, receiver=receiver_user).exists() or \
               Friendship.objects.filter(sender=receiver_user, receiver=request.user).exists():
                return Response(
                    {"error": "Friendship already exists or request pending"},
                    status=status.HTTP_400_BAD_REQUEST,
                )

            # Create the friendship request
            Friendship.objects.create(
                sender=request.user,
                receiver=receiver_user,
                friend_request_sent=True
            )
            return Response(
                {"message": "Friend request successfully sent"},
                status=status.HTTP_201_CREATED,
            )
        except MyUser.DoesNotExist:
            return Response({"error": "User not found"}, status=status.HTTP_404_NOT_FOUND)
        except IntegrityError:
            return Response(
                {"error": "Database error while creating the friend request"},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR,
            )

        
class AcceptFriendRequestView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request, *args, **kwargs):
        # Retrieve the `request_id` from the request data
        request_id = request.data.get('request_id')

        if not request_id:
            return Response(
                {"msg": "request_id is required."},
                status=status.HTTP_400_BAD_REQUEST
            )

        try:
            # Fetch the friendship object
            friendship = Friendship.objects.get(
                id=request_id,
                receiver=request.user,
                is_accepted=False
            )

            # Accept the friend request
            friendship.is_accepted = True
            friendship.save()

            return Response(
                {"msg": "Friend request accepted."},
                status=status.HTTP_200_OK
            )

        except Friendship.DoesNotExist:
            return Response(
                {"msg": "Friend request not found or already accepted."},
                status=status.HTTP_404_NOT_FOUND
            )



class ViewFriendList(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, *args, **kwargs):
        # Fetch all accepted friendships where the logged-in user is either the sender or the receiver
        friendships = Friendship.objects.filter(
            Q(sender=request.user) | Q(receiver=request.user),
            is_accepted=True
        )
        
        # Create a list to store friends
        friends = []
        
        # Populate the friends list by checking sender and receiver
        for friendship in friendships:
            if friendship.sender == request.user:
                friends.append(friendship.receiver)  # Add receiver to the friends list
            else:
                friends.append(friendship.sender)  # Add sender to the friends list
        
        # Serialize the friends list
        serializer = UserProfileSerializers(friends, many=True)
        
        # Return the serialized data
        return Response(serializer.data, status=200)
    
class ChatHistoryView(APIView):
    def get(self, request, me_id, frnd_id):
        try:
            # Sort the IDs to ensure consistency
            sorted_ids = sorted([me_id, frnd_id])

            me = MyUser.objects.get(id=sorted_ids[0])
            frnd = MyUser.objects.get(id=sorted_ids[1])

            chat = MyChats.objects.filter(me=me, frnd=frnd).first()

            if chat:
                return Response(chat.chats)  # Return the list of messages
            else:
                return Response([])  # Return empty list if no chat history found
        except MyUser.DoesNotExist:
            return Response({"error": "User does not exists"}, status=400)
        
            
    
    

        
            
        
            
            
        

                

        
