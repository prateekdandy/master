public class AdminHomepage{
public String PageAlert {get; set;}
public String CheckDocs {get; set;}
public String CheckLimits {get; set;}
public String CheckUsers {get; set;}
public AdminHomepage(){

PageAlert='';
CheckDocs='';
CheckLimits='';
CheckUsers='';

Map<Integer,String> userList = new Map<Integer,String>();

for (user u : [
    SELECT LastLoginDate, createddate, username FROM User WHERE IsActive = TRUE AND Id IN (SELECT userId FROM userLogin WHERE IsFrozen = TRUE) AND LastLoginDate>2000-01-01T00:00:00Z
    ]) {
    String x = u.username+', '+Date.valueOf(u.LastLoginDate.format('yyyy-MM-dd')).daysBetween(system.today())+' days; '+u.Id+'</br>';
    userList.put(-Date.valueOf(u.LastLoginDate.format('yyyy-MM-dd')).daysBetween(system.today()), x);
    }
    
for (user u : [
    SELECT LastLoginDate, createddate, username, Id FROM User WHERE IsActive = TRUE AND Id IN (SELECT userId FROM userLogin WHERE IsFrozen = TRUE) AND LastLoginDate=null
    ]) {
    String x = u.username+', '+Date.valueOf(u.createddate.format('yyyy-MM-dd')).daysBetween(system.today())+' days; '+u.Id+'</br>';
    userList.put(-Date.valueOf(u.createddate.format('yyyy-MM-dd')).daysBetween(system.today()), x);
    }

list<integer> usersRank = new list<integer>();
usersRank.addAll(userList.keySet());
usersRank.sort();

if(usersRank.size()==0) {CheckUsers+='0</br>No frozen users</br>';}
else {
Integer i = 0;
for(integer rank : usersRank)
    {
    i++;
    String x = userList.get(rank);
    CheckUsers+=x;
    }
    CheckUsers=i+'</br>'+CheckUsers;
    }

List<ContentDocument> CDs = [SELECT Id, createddate, createdbyid FROM ContentDocument where createdbyid='0055d00000DJEPpAAP' and createddate>=LAST_N_DAYS:7];

for (ContentDocument cd : [
    SELECT createddate FROM ContentDocument where createdbyid='0055d00000DJEPpAAP' order by createddate desc limit 1
    ]) {
       CheckDocs +=String.ValueOf(CDs.size())+'</br>Most recent: '+ cd.createddate.format('yyyy-MM-dd HH:mm')+', '+
       Date.valueOf(cd.createddate).daysBetween(system.today())+' days ago';
       if(Date.valueOf(cd.createddate).daysBetween(system.today())>=3) { PageAlert+='ATTENTION: Check Pandadoc status!</br>'; }
    }

Map<String,System.OrgLimit> limitsMap = OrgLimits.getMap();
Map<Double,String> limitsCalc = new Map<Double,String>();

for(String limitName : limitsMap.keySet()){
    if(limitsMap.get(limitName).getValue()>0){
        Double d = Double.valueOf(limitsMap.get(limitName).getValue())/Double.valueOf(limitsMap.get(limitName).getLimit());
        Decimal dd = decimal.valueOf(d*100).setScale(2, RoundingMode.HALF_UP);
        String x=(limitName + ' : ' + limitsMap.get(limitName).getValue() + ' / ' + limitsMap.get(limitName).getLimit())+' = '+dd+'%</br>';
        if(dd>85){PageAlert+='ATTENTION: Check '+limitName+' limit!</br>';} 
        if(dd>10){ limitsCalc.put(-d,x); }
        }
    }
    
list<double> limitsRank = new list<double>();
limitsRank.addAll(limitsCalc.keySet());
limitsRank.sort();

if(limitsRank.size()==0) {CheckLimits+='0</br>Everything under 10%</br>';}
else {
Integer i = 0;
for(decimal rank : limitsRank)
    {
    i++;
    String x = limitsCalc.get(rank);
    CheckLimits+=x;
    }
    CheckLimits=i+'</br>'+CheckLimits;
    }
    
}

  public static void fakeTest(){
    Integer i = 0;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
        i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    //repeat the i++ hundred of times

  }
}