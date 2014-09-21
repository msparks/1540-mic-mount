OPENSCAD ?= $(shell which openscad)
ifeq ($(OPENSCAD),)
  OPENSCAD = /Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD
endif

MODELS = 1540_mic_mount.stl
VARS = -D '$$fs=0.1' -D '$$fa=0.1'

%.stl: %.scad
	$(OPENSCAD) $(VARS) --render -o $*.stl $^

all: $(MODELS)

clean:
	rm -f $(MODELS)
