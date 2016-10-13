
# Copyright (c) 2016, The developers of the Stanford CRN 
# All rights reserved. 
# 
# Redistribution and use in source and binary forms, with or without 
# modification, are permitted provided that the following conditions are met: 
# 
# * Redistributions of source code must retain the above copyright notice, this 
#   list of conditions and the following disclaimer. 
# 
# * Redistributions in binary form must reproduce the above copyright notice, 
#   this list of conditions and the following disclaimer in the documentation 
#   and/or other materials provided with the distribution. 
# 
# * Neither the name of crn_base nor the names of its 
#   contributors may be used to endorse or promote products derived from 
#   this software without specific prior written permission. 
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE 
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE 
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL 
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR 
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, 
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. 

 
# uses the image with freesurfer from oesteban/crn_base@sha256:2ef833b78bfb3aae2e34ca891b165a04e7e1cacb26e07ca0ae35d52d4f1f99ec
FROM poldracklab/mriqc@sha256:b994ec84c7371dcfb29699116c0d3f12492fb188cc5442083c4b1ae1cc323e4f

ENV SHELL /bin/bash 
ENV AFNI_INSTALLDIR=/usr/lib/afni \
PATH=${PATH}:/usr/lib/afni/bin \
AFNI_PLUGINPATH=/usr/lib/afni/plugins \
AFNI_MODELPATH=/usr/lib/afni/models \
AFNI_TTATLAS_DATASET=/usr/share/afni/atlases \
AFNI_IMSAVE_WARNINGS=NO 
ENV PATH=/usr/lib/afni:$PATH 


RUN pip uninstall -y mriqc && \
pip install git+https://github.com/nih-fmrif/mriqc.git@c9af67f74c295852e6b835af5191562575e4770a#egg=mriqc
# jan to add the appropriate commit hash
RUN python -c "from matplotlib import font_manager"
RUN mkdir /gpfs /spin1 /gs2 /gs3 /gs4 /gs5 /data /fdb /lscratch /scratch /fmrif /sfim /users

ENTRYPOINT ["/bin/bash"] 
