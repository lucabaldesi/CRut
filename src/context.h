#ifndef __CONTEXT_H__
#define  __CONTEXT_H__

#include<mongoose.h>
#include<router.h>
#include<task_manager.h>

struct context{
	struct mg_serve_http_opts http_opts;
	char http_port[16];
	struct router * router;
	struct task_manager * tm;
	struct mg_mgr * mongoose_srv;
};

#endif

