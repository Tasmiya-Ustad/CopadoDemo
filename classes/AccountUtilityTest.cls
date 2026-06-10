@isTest
public class AccountUtilityTest {
    
    // Setup test data
    @testSetup
    static void setupTestData() {
        
        // Create accounts with phone
        List<Account> accountsWithPhone = new List<Account>();
        for(Integer i = 0; i < 5; i++) {
            accountsWithPhone.add(new Account(
                Name = 'Test Account With Phone ' + i,
                Phone = '123-456-789' + i,
                Industry = 'Technology',
                AnnualRevenue = 100000 * (i + 1)
            ));
        }
        
        // Create accounts without phone
        List<Account> accountsNoPhone = new List<Account>();
        for(Integer i = 0; i < 3; i++) {
            accountsNoPhone.add(new Account(
                Name = 'Test Account No Phone ' + i,
                Industry = 'Finance',
                AnnualRevenue = 50000 * (i + 1)
            ));
        }
        
        insert accountsWithPhone;
        insert accountsNoPhone;
    }
    
    // Test flagAccountsWithNoPhone method
    @isTest
    static void testFlagAccountsWithNoPhone() {
        
        Test.startTest();
        AccountUtility.flagAccountsWithNoPhone();
        Test.stopTest();
        
        // Verify accounts with no phone got description updated
        List<Account> updatedAccounts = [
            SELECT Id, Description 
            FROM Account 
            WHERE Phone = null
        ];
        
        for(Account acc : updatedAccounts) {
            System.assertEquals(
                'ACTION REQUIRED: No phone number on record. Please update.',
                acc.Description,
                'Description should be updated for accounts with no phone'
            );
        }
    }
    
    // Test getAccountCountByIndustry method
    @isTest
    static void testGetAccountCountByIndustry() {
        
        Test.startTest();
        Map<String, Integer> industryMap = AccountUtility.getAccountCountByIndustry();
        Test.stopTest();
        
        // Verify map is not empty
        System.assertNotEquals(0, industryMap.size(), 'Industry map should not be empty');
        
        // Verify Technology industry count
        System.assertEquals(5, industryMap.get('Technology'), 'Should have 5 Technology accounts');
        
        // Verify Finance industry count
        System.assertEquals(3, industryMap.get('Finance'), 'Should have 3 Finance accounts');
    }
    
    // Test getTopAccountsByRevenue method
    @isTest
    static void testGetTopAccountsByRevenue() {
        
        Test.startTest();
        List<Account> topAccounts = AccountUtility.getTopAccountsByRevenue();
        Test.stopTest();
        
        // Verify we get accounts back
        System.assertNotEquals(0, topAccounts.size(), 'Should return top accounts');
        
        // Verify limit of 5
        System.assert(topAccounts.size() <= 5, 'Should return max 5 accounts');
    }
}