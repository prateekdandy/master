public class UsersFrozen{
public String FURCount {get; set;}
public String FURList {get; set;}
public UsersFrozen(){
List<User> FURs = [SELECT Name, IsActive, LastLoginDate, Id, username FROM User WHERE IsActive = TRUE AND Id IN (SELECT userId FROM userLogin WHERE IsFrozen = TRUE)];
FURCount = String.ValueOf(FURs.size());
FURList = String.join(FURs, '; ');
}
}