using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Amazon.SecretsManager;
using Amazon.SecretsManager.Model;

namespace API.Helper
{
    public static class SecretsHelper
    {
        private static readonly AmazonSecretsManagerClient _client = new AmazonSecretsManagerClient(Amazon.RegionEndpoint.APSoutheast1);

        public class AppSecrets
        {
            public string DBConnectionString { get; set; } = null;
            public string JwtSecret { get; set; } = null;
            public string JwtIssuer { get; set; } = null;
            public string JwtAudience { get; set; } = null;
        }

        public static async Task<string> GetSecretValueAsync(string secretName)
        {
            var response = await _client.GetSecretValueAsync(new GetSecretValueRequest
            {
                SecretId = secretName
            });

            if (string.IsNullOrEmpty(response.SecretString))
                throw new InvalidOperationException($"Secret {secretName} is empty");

            return response.SecretString;
        }

        public static async Task<AppSecrets> GetSecretsForEnvironmentAsync(string environment)
        {
            if (environment == "LOCAL")
            {
                return new AppSecrets
                {
                    DBConnectionString = Environment.GetEnvironmentVariable("DB_CONNECTION_STRING")
                                            ?? throw new InvalidOperationException("DB_CONNECTION_STRING not set"),
                    JwtSecret = Environment.GetEnvironmentVariable("JWT_SECRET")
                                    ?? throw new InvalidOperationException("JWT_SECRET not set"),
                    JwtIssuer = Environment.GetEnvironmentVariable("JWT_ISSUER")
                                    ?? throw new InvalidOperationException("JWT_ISSUER not set"),
                    JwtAudience = Environment.GetEnvironmentVariable("JWT_AUDIENCE")
                                    ?? throw new InvalidOperationException("JWT_AUDIENCE not set")

                };
            }

            var dbSecretName = environment == "Development"
                ? "CMS_DB_TEST_CONNECTION_STRING"
                : "CMS_DB_PROD_CONNECTION_STRING";

            var dbConnectionString = await GetSecretValueAsync(dbSecretName);
            var jwtSecret = await GetSecretValueAsync("JWT_SECRET");
            var jwtIssuer = await GetSecretValueAsync("JWT_ISSUER");
            var jwtAudience = await GetSecretValueAsync("JWT_AUDIENCE");

            return new AppSecrets
            {
                DBConnectionString = dbConnectionString,
                JwtSecret = jwtSecret,
                JwtIssuer = jwtAudience,
                JwtAudience = jwtAudience
            };
        }
    }
}