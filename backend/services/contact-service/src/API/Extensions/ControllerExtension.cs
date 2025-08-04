using Microsoft.AspNetCore.Mvc;
using Shared.Common;

namespace ContactService.API.Extensions;

public static class ControllerExtensions
{
    public static IActionResult FromResult(this ControllerBase controller, Result result)
    {
        return result.Match<IActionResult>(
            onSuccess: () => controller.Ok(),
            onFailure: error => controller.Problem(title: error.Code, detail: error.Message)
        );
    }

    public static IActionResult FromResult<T>(this ControllerBase controller, Result<T> result)
    {
        return result.Match<IActionResult>(
            onSuccess: value => controller.Ok(value),
            onFailure: error => controller.Problem(title: error.Code, detail: error.Message)
        );
    }
}