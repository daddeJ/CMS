using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

[ApiController]
[Route("api/[controller]")]
public class ImagesController : ControllerBase
{
    private readonly IWebHostEnvironment _env;

    public ImagesController(IWebHostEnvironment env)
    {
        _env = env;
    }

    [Authorize]
    [HttpGet("{contactId}/{imageName}")]
    public IActionResult GetImage(Guid contactId, string imageName)
    {
        var imagePath = Path.Combine(
            _env.ContentRootPath,
            "wwwroot",
            "uploads",
            "contacts",
            contactId.ToString(),
            $"{imageName}.jpg"
        );

        if (!System.IO.File.Exists(imagePath))
            return NotFound();

        return PhysicalFile(imagePath, "image/jpeg");
    }
}