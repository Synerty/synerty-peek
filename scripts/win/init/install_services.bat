sc create peek_logic_service binPath= "C:\Users\peek\synerty-peek-0.6.0\Scripts\winsvc_peek_logic_service.exe" type= own type= interact start= auto

sc create peek_worker_service binPath= "C:\Users\peek\synerty-peek-0.6.0\Scripts\winsvc_peek_worker_service.exe" type= own type= interact start= auto

sc create peek_agent_service binPath= "C:\Users\peek\synerty-peek-0.6.0\Scripts\winsvc_peek_agent_service.exe" type= own type= interact start= auto

sc create peek_office_service binPath= "C:\Users\peek\synerty-peek-0.6.0\Scripts\winsvc_peek_office_service.exe" type= own type= interact start= auto
