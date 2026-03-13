@IsTest
private class AccountServiceTest {

    // ── Test Data Factory ─────────────────────────────────────────────────────

    private static Account buildAccount(String name, String industry) {
        return new Account(Name = name, Industry = industry);
    }

    // ── searchByName ──────────────────────────────────────────────────────────

    @IsTest
    static void searchByName_returnsMatchingAccounts() {
        insert buildAccount('Acme Corporation', 'Technology');
        insert buildAccount('Acme Supplies', 'Retail');
        insert buildAccount('Global Corp', 'Finance');

        Test.startTest();
            List<Account> results = AccountService.searchByName('Acme');
        Test.stopTest();

        System.assertEquals(2, results.size(), 'Expected 2 accounts matching "Acme"');
    }

    @IsTest
    static void searchByName_blankFilter_returnsEmpty() {
        Test.startTest();
            List<Account> results = AccountService.searchByName('');
        Test.stopTest();

        System.assert(results.isEmpty(), 'Blank filter should return an empty list');
    }

    @IsTest
    static void searchByName_noMatch_returnsEmpty() {
        insert buildAccount('Unique Name XYZ', 'Technology');

        Test.startTest();
            List<Account> results = AccountService.searchByName('NoMatchWhatsoever');
        Test.stopTest();

        System.assert(results.isEmpty(), 'No matching accounts should return empty list');
    }

    // ── createAccount ─────────────────────────────────────────────────────────

    @IsTest
    static void createAccount_success() {
        Test.startTest();
            Account acc = AccountService.createAccount('Test Account', 'Technology');
        Test.stopTest();

        System.assertNotEquals(null, acc.Id, 'Account should have been inserted and have an Id');
        Account fetched = [SELECT Name, Industry FROM Account WHERE Id = :acc.Id];
        System.assertEquals('Test Account', fetched.Name,     'Name should match');
        System.assertEquals('Technology',   fetched.Industry, 'Industry should match');
    }

    @IsTest
    static void createAccount_blankName_throwsException() {
        Test.startTest();
            try {
                AccountService.createAccount('', 'Technology');
                System.assert(false, 'Expected AccountServiceException was not thrown');
            } catch (AccountService.AccountServiceException ex) {
                System.assert(
                    ex.getMessage().contains('cannot be blank'),
                    'Exception message should mention blank name'
                );
            }
        Test.stopTest();
    }
}