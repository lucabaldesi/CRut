/*******************************************************************
* Copyright (C) 2017 Luca Baldesi <luca.baldesi@unitn.it>
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU Affero General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU Affero General Public License for more details.
*
* You should have received a copy of the GNU Affero General Public License
* along with this program.  If not, see <http://www.gnu.org/licenses/>.
*******************************************************************/

#include<periodic_task_intfs.h>
#include<mongoose.h>
#include<debug.h>

void add_fd_to_fdset(void * handler, int sock, char set)
{
	struct periodic_task * pt;

	pt = (struct periodic_task *) handler;

	switch (set)
	{
		case 'r':
			periodic_task_readfd_add(pt, sock);
			break;
		case 'w':
			periodic_task_writefd_add(pt, sock);
			break;
		case 'e':
			periodic_task_errfd_add(pt, sock);
			break;
		default:
			fprintf(stderr, "[ERROR] sock insertion\n");
	}
}



uint8_t mongoose_task_callback(struct periodic_task * pt, int ret, fd_set * readfds, fd_set * writefds, fd_set * errfds)
{
	struct mg_iface *iface;

	iface = (struct mg_iface *) periodic_task_get_data(pt);

	if (ret == 0)
		debug("Mongoose timeout\n");
	return mongoose_select_action(iface, ret, readfds, writefds, errfds);
}


uint8_t mongoose_task_reinit(struct periodic_task * pt)
{
	struct mg_iface *iface;
	timeout timeout_ms;

	iface = (struct mg_iface *) periodic_task_get_data(pt);

	timeout_ms = periodic_task_get_remaining_time(pt);
	if (timeout_ms == 0)
		timeout_ms = periodic_task_reset_timeout(pt);

	periodic_task_flush_fdsets(pt);

	timeout_ms = mongoose_select_init(iface, add_fd_to_fdset, (void*) pt, timeout_ms);
	periodic_task_set_remaining_time(pt, timeout_ms);

	return 0;
}
