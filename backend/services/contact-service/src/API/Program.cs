using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using System.Text;
using DotNetEnv;
using ContactService.Application.Profiles;
using ContactService.Domain.Interfaces;
using ContactService.Infrastructure.Repositories;
using ContactService.Application.Interfaces;
using ContactService.Application.Services;
using ContactService.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;
using ContactService.API.Services;
using API.Helper;
using Amazon.S3;
using API.Services;

var builder = WebApplication.CreateBuilder(args);

DotNetEnv.Env.Load("../../../../.env");

var environment = builder.Environment.EnvironmentName;
var secrets = await SecretsHelper.GetSecretsForEnvironmentAsync(environment);

var key = Encoding.ASCII.GetBytes(secrets.JwtSecret);

builder.Services.AddAuthentication(options =>
{
    options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
    options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
})
.AddJwtBearer(options =>
{
    options.RequireHttpsMetadata = false;
    options.SaveToken = true;
    options.TokenValidationParameters = new TokenValidationParameters
    {
        ValidateIssuerSigningKey = true,
        IssuerSigningKey = new SymmetricSecurityKey(key),
        ValidateIssuer = true,
        ValidIssuer = secrets.JwtIssuer,
        ValidateAudience = true,
        ValidAudience = secrets.JwtAudience,
        ValidateLifetime = true,
        ClockSkew = TimeSpan.Zero
    };
});

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new() { Title = "Contact Service API", Version = "v1" });

    var securityScheme = new Microsoft.OpenApi.Models.OpenApiSecurityScheme
    {
        Name = "Authorization",
        Description = "Enter: Bearer {your JWT}",
        In = Microsoft.OpenApi.Models.ParameterLocation.Header,
        Type = Microsoft.OpenApi.Models.SecuritySchemeType.Http,
        Scheme = "bearer",
        BearerFormat = "JWT",
        Reference = new Microsoft.OpenApi.Models.OpenApiReference
        {
            Type = Microsoft.OpenApi.Models.ReferenceType.SecurityScheme,
            Id = "Bearer"
        }
    };

    c.AddSecurityDefinition("Bearer", securityScheme);
    c.AddSecurityRequirement(new Microsoft.OpenApi.Models.OpenApiSecurityRequirement
    {
        { securityScheme, Array.Empty<string>() }
    });
});

builder.Services.AddDbContext<ContactDbContext>(options =>
    options.UseSqlServer(secrets.DBConnectionString));

builder.Services.AddAutoMapper(typeof(ContactProfile).Assembly);
builder.Services.AddScoped<IContactRepository, ContactRepository>();
builder.Services.AddScoped<IContactService, ContactApplicationService>();
builder.Services.AddScoped<IContactImageService, ContactImageService>();

if (environment.Equals("LOCAL", StringComparison.OrdinalIgnoreCase))
{
    builder.Services.AddScoped<IFileStorageService, LocalFileStorageService>();
}
else
{
    builder.Services.AddAWSService<IAmazonS3>();
    builder.Services.AddScoped<IFileStorageService>(sp =>
    {
        var s3Client = sp.GetRequiredService<IAmazonS3>();
        var bucketName = Environment.GetEnvironmentVariable("S3_BUCKET")
                         ?? throw new InvalidOperationException("S3_BUCKET not set");
        return new RemoteFileStorageService(s3Client, bucketName);
    });
}

builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", policy =>
    {
        policy.AllowAnyOrigin()
              .AllowAnyMethod()
              .AllowAnyHeader();
    });
});
builder.WebHost.ConfigureKestrel(options =>
{
    options.Limits.MaxRequestBodySize = long.MaxValue;
});

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseCors("AllowAll");
app.UseAuthentication();
app.UseAuthorization();
app.UseStaticFiles();
app.MapControllers();

app.Run();
