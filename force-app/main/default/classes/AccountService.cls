public with sharing class AccountService {

    /**
     * Returns a list of Accounts by name (partial match, case-insensitive).
     */
    public static List<Account> searchByName(String nameFilter) {
        if (String.isBlank(nameFilter)) {
            return new List<Account>();
        }
        String likeFilter = '%' + nameFilter.trim() + '%';
        return [
            SELECT Id, Name, Phone, Industry
            FROM Account
            WHERE Name LIKE :likeFilter
            ORDER BY Name ASC
            LIMIT 200
        ];
    }

    /**
     * Creates a new Account with the given name and returns it.
     */
    public static Account createAccount(String name, String industry) {
        if (String.isBlank(name)) {
            throw new AccountServiceException('Account name cannot be blank.');
        }
        Account acc = new Account(
            Name     = name.trim(),
            Industry = industry
        );
        insert acc;
        return acc;
    }

    /**
     * Custom exception for AccountService errors.
     */
    public class AccountServiceException extends Exception {}
}