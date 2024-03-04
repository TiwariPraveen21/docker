
class AppString{

//Login Screen
 static const lgn ="LOG IN";
 static const aldtls ="Please Fill all the Detials";

  static const msgerror = "Message can not be empty";

  static const mailhint = "Email Your Email";
  static const maillabel = "Email";
  static const mailempt = "Email is Required";
  static const mailregex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
   static const mailerr = "Enter Correct Mail Address";

   static const mobilehint = "Email Your Mobile Number";
  static const mobilelabel = "Number";
  static const mobilempt = "Number is Required";
  static const mobilegex = r'^[6-9]\d{9}$';
   static const mobileerr = "Enter Correct Mobile Number";
   
  static const passhint = "Enter Your Password";
  static const passlabel = "Password";
  static const passempt = "Password is Required";
  static const passregex =  r'^(?=.*[A-Z])(?=.*[!@#$%^&*()_+{}|:;<>,.?~])[A-Za-z\d!@#$%^&*()_+{}|:;<>,.?~]{8,}$';
   static const passerr = "Hint : Include at least 8 characters,one uppercase and Special character";

  //change password
  static const changepasshint = "Enter current Password";
  static const changepasslabel = "Enter current Password";
   static const conchangepasshint = "Enter New Password";
   static const conchangepasslabel = "Enter New Password";
    static const changebtn = "ENTER";
    static const yespassword = "Remeber your password ? Go Back";
    static const changepsderror = "Current and new Password can not be same";

 static const cpasshint = "Re-Inter your Password";
  static const cpasslabel = "Confirm Password";
  static const cpassempt = "Password is Required";
  static const cpassmatch = "Password does not Match";
  static const cpassregex =   r'^(?=.*[A-Z])(?=.*[!@#$%^&*()_+{}|:;<>,.?~])[A-Za-z\d!@#$%^&*()_+{}|:;<>,.?~]{8,}$';
   static const cpasserr = "Hint : Include at least 8 characters,one uppercase and Special character";
   

  
  static const psdtxt = "Enter Your Password";
  static const ggltxt = "SignIn with Google";
  static const noacount =  "Don't Have an Account? Sign up";
  static const yesaccount = "Already Have an Account? Sign in";


static const forgot = "Forgot your password?";


  static const page3Titl = 'You can do much more with Infoprofile.';
  static const page3Img = 'assets/images/LetsGo.png';
  static const page3Des ='Are you ready to transform the way you interact with your information' ;
  static const signup = "SIGN UP";


//Api String
static const baseUrl = "https://api.openweathermap.org/data/2.5/weather";



}


