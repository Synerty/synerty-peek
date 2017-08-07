sc create peek_server binPath= "C:\Users\peek\synerty-peek-0.6.0\Scripts\winsvc_peek_server.exe" type= own type= interact start= auto

sc create peek_worker binPath= "C:\Users\peek\synerty-peek-0.6.0\Scripts\winsvc_peek_worker.exe" type= own type= interact start= auto

sc create peek_agent binPath= "C:\Users\peek\synerty-peek-0.6.0\Scripts\winsvc_peek_agent.exe" type= own type= interact start= auto

sc create peek_client binPath= "C:\Users\peek\synerty-peek-0.6.0\Scripts\winsvc_peek_client.exe" type= own type= interact start= auto
