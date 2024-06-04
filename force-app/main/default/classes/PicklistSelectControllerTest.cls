/*
 * Created by Rod on 3/13/2019.
 */


@isTest
public class PicklistSelectControllerTest {
	@IsTest static void test1() {
		PicklistSelectController.getFieldLabel('Account','Name');
		PicklistSelectController.getPicklistOptions('Opportunity','Am_Is_This_Account_At_Risk__c');


	}
}