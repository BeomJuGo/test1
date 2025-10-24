import org.mindrot.jbcrypt.BCrypt;

public class test_bcrypt {
  public static void main(String[] args) {
    String storedHash = "$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy";
    String password = "password123";

    System.out.println("Testing BCrypt verification:");
    System.out.println("Stored hash: " + storedHash);
    System.out.println("Password: " + password);

    boolean result = BCrypt.checkpw(password, storedHash);
    System.out.println("Verification result: " + result);

    // Test with wrong password
    boolean wrongResult = BCrypt.checkpw("wrongpassword", storedHash);
    System.out.println("Wrong password result: " + wrongResult);
  }
}
