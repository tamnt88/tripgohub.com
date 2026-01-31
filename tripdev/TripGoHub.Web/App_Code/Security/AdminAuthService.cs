using System;
using System.Linq;
using System.Security.Cryptography;

namespace TripGoHub.Web.Security
{
    public interface IAdminAuthService
    {
        AdminUser ValidateLogin(string username, string password);
    }

    public class AdminAuthService : IAdminAuthService
    {
        public AdminUser ValidateLogin(string username, string password)
        {
            if (string.IsNullOrWhiteSpace(username) || string.IsNullOrWhiteSpace(password))
            {
                return null;
            }

            using (var db = new TripGoHubDbContext())
            {
                var user = db.AdminUsers.FirstOrDefault(x => x.Username == username && x.Status == 1);
                if (user == null)
                {
                    return null;
                }

                return VerifyPassword(password, user.PasswordSalt, user.PasswordHash) ? user : null;
            }
        }

        private static bool VerifyPassword(string password, byte[] salt, byte[] hash)
        {
            if (salt == null || hash == null)
            {
                return false;
            }

            using (var sha = SHA512.Create())
            {
                // Match SQL Server NVARCHAR hashing (UTF-16LE)
                var passBytes = System.Text.Encoding.Unicode.GetBytes(password);
                var combined = new byte[salt.Length + passBytes.Length];
                Buffer.BlockCopy(salt, 0, combined, 0, salt.Length);
                Buffer.BlockCopy(passBytes, 0, combined, salt.Length, passBytes.Length);
                var computed = sha.ComputeHash(combined);
                return SlowEquals(computed, hash);
            }
        }

        private static bool SlowEquals(byte[] a, byte[] b)
        {
            if (a == null || b == null || a.Length != b.Length)
            {
                return false;
            }

            var diff = 0;
            for (var i = 0; i < a.Length; i++)
            {
                diff |= a[i] ^ b[i];
            }

            return diff == 0;
        }
    }
}
