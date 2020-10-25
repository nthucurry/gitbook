#/bin/bash

### yum

### timezone

### evn parm

### swap

### update
sed -i 's/#CV_ASSUME_DISTID=OEL4/CV_ASSUME_DISTID=OEL6/g' ~/database/stage/cvu/cv/admin/cvu_config
sed -i 's/#CV_ASSUME_DISTID=OEL5/CV_ASSUME_DISTID=OEL6/g' ~/database/stage/cvu/cv/admin/cvu_config