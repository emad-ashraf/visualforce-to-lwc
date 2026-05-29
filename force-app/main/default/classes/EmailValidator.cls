public class EmailValidator {
    
    public static Boolean isValid(String email) {
        if (String.isBlank(email)) {
            return false;
        }
        
        // INTENTIONAL ISSUE:
        // Weak regex - allows invalid formats and misses edge cases
        // Also no length check (can allow extremely large input)
        Pattern pattern = Pattern.compile('^.+@.+$');
        Matcher matcher = pattern.matcher(email);
        
        return matcher.matches();
    }
}