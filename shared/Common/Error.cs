namespace Shared.Common;

public record Error(string Code, string Message, ErrorType Type = ErrorType.Failure)
{
    public static readonly Error None = new(string.Empty, string.Empty, ErrorType.None);
    public static readonly Error NullValue = new("Error.NullValue", "The specified value is null.", ErrorType.Failure);
    public static Error NotFound(string code, string message)
        => new(code, message, ErrorType.NotFound);
    public static Error Validation(string code, string message)
        => new(code, message, ErrorType.Validation);
    public static Error Conflict(string code, string message)
        => new(code, message, ErrorType.Conflict);
    public static Error Failure(string code, string message)
        => new(code, message, ErrorType.Failure);
    public static Error Unauthorized(string code, string message)
        => new(code, message, ErrorType.Unauthorized);
    public static Error Forbidden(string code, string message)
        => new(code, message, ErrorType.Forbidden);
}

public enum ErrorType
{
    None,
    Failure,
    Validation,
    NotFound,
    Conflict,
    Unauthorized,
    Forbidden
}