#include<path_handlers.h>


uint8_t load_path_handlers(struct router *r)
/* add here your mapping of HTTP requests and control function, e.g,:
 *
   res |= router_add_route(r, "POST", "^[/]+my_resource$", resource_control); 
 *
 * 2. argument is the HTTP method,
 * 3. argument is the regular expression for matching the requested URI,
 * 4. argument is the path handler function defined in path_handlers.h
*/
{
	uint8_t res = 0;

	return res;
}
