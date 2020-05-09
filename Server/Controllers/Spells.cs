using System;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using System.IO;
using Microsoft.AspNetCore.Hosting;

namespace Server.Controllers
{
    [Route("api/[controller]")]
    public class Spells : Controller
    {
        public IWebHostEnvironment _hostEnvironment { get; }

        public Spells(IWebHostEnvironment hostEnvironment)
        {
            _hostEnvironment = hostEnvironment;
        }

        // GET: api/values
        [HttpGet]
        public Compendium Get()
        {
            string path = Path.Combine(
                _hostEnvironment.ContentRootPath
                , "AppData"
                , "SpellData.xml");

            return Compendium.Load(path);
        }

    }
}
