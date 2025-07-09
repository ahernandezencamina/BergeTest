using Microsoft.AspNetCore.Mvc;

namespace Berge.Core.IA.DocumentProccessor.Controllers
{
    /// <summary>
    /// <see langword="this"/> controller se encarga de procesar mensajes de Service Bus que contienen informaci�n de pedidos y extraer datos de facturas en formato PDF.
    /// </summary>
    [ApiController]
    [Route("api/[controller]")]
    public class ProcessController : ControllerBase
    {
        private readonly ILogger<ProcessController> logger;

        /// <summary>
        /// Constructor para inyectar dependencias necesarias para el procesamiento de documentos.
        /// </summary>
        public ProcessController(ILogger<ProcessController> logger)
        {
            this.logger = logger;
        }

        /// <summary>
        /// Creates a new resource with the provided name and value.
        /// </summary>
        /// <param name="name">The name of the resource.</param>
        /// <param name="value">The value of the resource.</param>
        /// <returns>A confirmation message.</returns>
        [HttpPost]
        public ActionResult<string> Create([FromQuery] string name, [FromQuery] string value)
        {
            return Ok($"Resource created: Name={name}, Value={value}");
        }

        /// <summary>
        /// Retrieves a resource by its identifier.
        /// </summary>
        /// <param name="id">The identifier of the resource.</param>
        /// <returns>A message with the requested identifier.</returns>
        [HttpGet("{id}")]
        public ActionResult<string> Read(int id)
        {
            return Ok($"Resource retrieved: Id={id}");
        }

        /// <summary>
        /// Updates an existing resource with the provided name and value.
        /// </summary>
        /// <param name="id">The identifier of the resource.</param>
        /// <param name="name">The new name of the resource.</param>
        /// <param name="value">The new value of the resource.</param>
        /// <returns>A confirmation message for the update.</returns>
        [HttpPut("{id}")]
        public ActionResult<string> Update(int id, [FromQuery] string name, [FromQuery] string value)
        {
            return Ok($"Resource updated: Id={id}, Name={name}, Value={value}");
        }

        /// <summary>
        /// Deletes a resource by its identifier.
        /// </summary>
        /// <param name="id">The identifier of the resource.</param>
        /// <returns>A confirmation message for the deletion.</returns>
        [HttpDelete("{id}")]
        public ActionResult<string> Delete(int id)
        {
            return Ok($"Resource deleted: Id={id}");
        }
    }
}
