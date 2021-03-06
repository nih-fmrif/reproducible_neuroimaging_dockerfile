
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
#
# Last modified: 10-17-2016 @ 15:55
# Last modified by: Jan Varada <jan.varada@nih.gov>
#
#################################################################################

 
# Uses the following base image from oesteban/crn_base: sha256:2ef833b78bfb3aae2e34ca891b165a04e7e1cacb26e07ca0ae35d52d4f1f99ec
# Includes Freesurfer, AFNI, FSL
FROM oesteban/crn_base@sha256:2ef833b78bfb3aae2e34ca891b165a04e7e1cacb26e07ca0ae35d52d4f1f99ec

# Install ghostscript (preferred PDF generator for MRIQC - smaller filesizes than python implementation)
RUN apt-get -y update && \
    apt-get install -y ghostscript && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Configure the user environment with AFNI's env variables
ENV SHELL /bin/bash 
ENV AFNI_INSTALLDIR=/usr/lib/afni \
    PATH=${PATH}:/usr/lib/afni/bin \
    AFNI_PLUGINPATH=/usr/lib/afni/plugins \
    AFNI_MODELPATH=/usr/lib/afni/models \
    AFNI_TTATLAS_DATASET=/usr/share/afni/atlases \
    AFNI_IMSAVE_WARNINGS=NO 
ENV PATH=/usr/lib/afni:$PATH

# Install miniconda
RUN curl -sSLO https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    /bin/bash Miniconda3-latest-Linux-x86_64.sh -b -p /usr/local/miniconda && \
    rm Miniconda3-latest-Linux-x86_64.sh
ENV PATH /usr/local/miniconda/bin:$PATH

# http://bugs.python.org/issue19846
# > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks Python 3*, and that's not OK.
ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

# Create conda environment, use following nipype/rst2pdf commits (current as of 10-17-2016):
RUN conda config --add channels conda-forge && \
    conda install -y numpy scipy lockfile matplotlib && \
    pip install -e git+https://github.com/nipy/nipype.git@master#egg=nipype && \
    pip install -e git+https://github.com/oesteban/rst2pdf.git@futurize/stage2#egg=rst2pdf && \
    python -c "from matplotlib import font_manager"

# Install NIH-FMRIF hosted version
# As of 10-17-2016 these are synchronized, but they might diverge in the future.
# Use commits from the "stable" branch hosted in FMRIF github
RUN pip install -e git+https://github.com/nih-fmrif/mriqc.git@stable#egg=mriqc

# Mount biowulf/fmrif/sfim directories for use within singularity containers
RUN mkdir /gpfs /spin1 /gs2 /gs3 /gs4 /gs5 /data /fdb /lscratch /scratch /fmrif /sfim /users

ENTRYPOINT ["/bin/bash"]
