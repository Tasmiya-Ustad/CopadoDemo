public class AccountUtility {
    
    // Method to find accounts with no phone and flag them
    public static void flagAccountsWithNoPhone() {
        
        List<Account> accountsToUpdate = new List<Account>();
        
        // Query all accounts where Phone is blank
        List<Account> accountsNoPhone = [
            SELECT Id, Name, Phone, Description 
            FROM Account 
            WHERE Phone = null
        ];
        
        // Loop through and update description
        for(Account acc : accountsNoPhone) {
            acc.Description = 'ACTION REQUIRED: No phone number on record. Please update.';
            accountsToUpdate.add(acc);
        }
        
        // Update records if list is not empty
        if(!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
            System.debug('Updated ' + accountsToUpdate.size() + ' accounts with no phone.');
        } else {
            System.debug('All accounts have phone numbers. No updates needed.');
        }
    }
    
    // Method to get count of accounts by Industry
    public static Map<String, Integer> getAccountCountByIndustry() {
        
        Map<String, Integer> industryCountMap = new Map<String, Integer>();
        
        // Query all accounts
        List<Account> allAccounts = [
            SELECT Id, Industry 
            FROM Account 
            WHERE Industry != null
        ];
        
        // Count accounts per industry
        for(Account acc : allAccounts) {
            if(industryCountMap.containsKey(acc.Industry)) {
                industryCountMap.put(acc.Industry, industryCountMap.get(acc.Industry) + 1);
            } else {
                industryCountMap.put(acc.Industry, 1);
            }
        }
        
        System.debug('Industry Count Map: ' + industryCountMap);
        return industryCountMap;
    }
    
    // Method to find top 5 accounts by Annual Revenue
    public static List<Account> getTopAccountsByRevenue() {
        
        List<Account> topAccounts = [
            SELECT Id, Name, AnnualRevenue, Industry, Phone
            FROM Account
            WHERE AnnualRevenue != null
            ORDER BY AnnualRevenue DESC
            LIMIT 5
        ];
        
        System.debug('Top 5 Accounts by Revenue: ' + topAccounts);
        return topAccounts;
    }
}