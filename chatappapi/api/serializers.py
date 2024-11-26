from api.models import MyUserManager, MyUser,ProfilePicture,Friendship
from rest_framework import serializers
class UserRegistrationSerializers(serializers.ModelSerializer):
    password2 = serializers.CharField(style={'input_type': 'password'}, write_only=True)

    class Meta:
        model = MyUser
        fields = ['email', 'name', 'password', 'password2']
        extra_kwargs = {
            'password': {'write_only': True}
        }

    def validate(self, attrs):
        password = attrs.get('password')
        password2 = attrs.get('password2')
        if password != password2:
            raise serializers.ValidationError("Passwords do not match")
        return attrs

    def create(self, validated_data):
        validated_data.pop('password2', None)
        return MyUser.objects.create_user(**validated_data)

class UserLoginSerializers(serializers.ModelSerializer):
    email = serializers.EmailField(max_length=255)
    password = serializers.CharField(max_length=255, write_only=True)

    class Meta:
        model = MyUser
        fields = ["email", "password"]
        
class UserProfileSerializers(serializers.ModelSerializer):
    class Meta:
        model = MyUser
        fields = "__all__"

class ChangePasswordSerializer(serializers.Serializer):
    password = serializers.CharField(max_length=32, style={'input_type': 'password'}, write_only=True)
    password2 = serializers.CharField(max_length=32, style={'input_type': 'password'}, write_only=True)

    def validate(self, attrs):
        password = attrs.get('password')
        password2 = attrs.get('password2')
        user = self.context.get('user')
        if password != password2:
            raise serializers.ValidationError("Passwords do not match")
        user.set_password(password)
        user.save()
        return attrs
    
class ProfilePictureSerializer(serializers.ModelSerializer):
    class Meta:
      model=ProfilePicture
      fields=["id","user","image","uploaded_at"]
      
      def create(self,validated_data):
          request=self.context.get("request")
          validated_data['user']=request.user
          return super().create(validated_data)
class FriendshipSerializer(serializers.ModelSerializer):
    sender=serializers.EmailField(source="sender.email",read_only=True)
    receiver=serializers.EmailField(source="receiver.email",read_only=True)
    class Meta:
        model=Friendship
        fields=["id","sender","receiver","is_accepted","created_at"]
        
      
        