#!/bin/bash

watch -n 5 'tail -n7 ~peek/*.log; echo;echo; $(echo ~peek/synerty-peek*/bin/cat_queues.sh | head -1)'

