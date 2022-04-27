#
# Makefile
#
# Copyright (c) 2012 - 2014 Robert Giseburt
# Copyright (c) 2013 - 2014 Alden S. Hart Jr.
#
#	This file is part of the Motate Library.
#
#	This file ("the software") is free software: you can redistribute it and/or modify
#	it under the terms of the GNU General Public License, version 2 as published by the
#	Free Software Foundation. You should have received a copy of the GNU General Public
#	License, version 2 along with the software. If not, see <http://www.gnu.org/licenses/>.
#
#	As a special exception, you may use this file as part of a software library without
#	restriction. Specifically, if other files instantiate templates or use macros or
#	inline functions from this file, or you compile this file and link it with  other
#	files to produce an executable, this file does not by itself cause the resulting
#	executable to be covered by the GNU General Public License. This exception does not
#	however invalidate any other reasons why the executable file might be covered by the
#	GNU General Public License.
#
#	THE SOFTWARE IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT WITHOUT ANY
#	WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
#	OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT
#	SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
#	OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

##############################################################################################
# Start of default section
#

BOARD  ?= NONE

MOTATE_PATH ?= $(dir "$(CURDIR)"/$(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST)))
export MOTATE_PATH

TOOLS_PATH ?= ${MOTATE_PATH}/../../Tools

SOURCE_DIRS ?= .
SOURCE_DIRS += ${MOTATE_PATH}

FIRST_LINK_SOURCES +=

# List all user directories here
USER_INCLUDE_DIRS += $(SOURCE_DIRS)

# List the user directory to look for the libraries here
USER_LIB_DIRS +=

# List all user libraries here
USER_LIBS +=

# Define optimisation level here
#OPTIMIZATION ?= 0
OPTIMIZATION ?= s
#OPTIMIZATION ?= 3

CFLAGS   +=
CPPFLAGS +=

#
# End of configuration section
##############################################################################################

##############################################################################################
# Start of configuration section
#

# ---------------------------------------------------------------------------------------
# C Flags (NOT CPP Flags)

# Configure warnings:
CFLAGS += -Wall -Wchar-subscripts -Wcomment -Wformat=2 -Wimplicit-int
CFLAGS += -Werror-implicit-function-declaration -Wmain -Wparentheses
CFLAGS += -Wsequence-point -Wreturn-type -Wswitch -Wtrigraphs -Wunused
CFLAGS += -Wuninitialized -Wno-unknown-pragmas -Wfloat-equal -Wundef
CFLAGS += -Wshadow -Wpointer-arith -Wbad-function-cast -Wwrite-strings
CFLAGS += -Wsign-compare -Waggregate-return
#CFLAGS += -Wstrict-prototypes
#CFLAGS += -Wmissing-prototypes -Wmissing-declarations
CFLAGS += -Wformat -Wmissing-format-attribute -Wno-deprecated-declarations
CFLAGS += -Wredundant-decls -Wnested-externs -Winline -Wlong-long
CFLAGS += -Wunreachable-code
#CFLAGS += -Wcast-align -Wpacked
#CFLAGS += -Wmissing-noreturn
#CFLAGS += -Wconversion

# Turn off printf() format strings. We use late bound FLASH and RAM format strings and this causes warnings
CFLAGS += -Wno-format-nonliteral -Wno-format-security

# ---------------------------------------------------------------------------------------
# CPP Flags

CPPFLAGS += -Wall -Wchar-subscripts -Wcomment -Wformat=2
CPPFLAGS += -Wmain -Wparentheses -Wunreachable-code
#CPPFLAGS += -Wcast-align
CPPFLAGS += -Wsequence-point -Wreturn-type -Wswitch -Wtrigraphs -Wunused
CPPFLAGS += -Wuninitialized -Wno-unknown-pragmas -Wfloat-equal -Wundef
CPPFLAGS += -Wshadow -Wpointer-arith -Wwrite-strings
#CPPFLAGS += -Wsign-compare -Waggregate-return -Wmissing-declarations
CPPFLAGS += -Wformat -Wmissing-format-attribute -Wno-deprecated-declarations
CPPFLAGS += -Wredundant-decls -Wlong-long
#CPPFLAGS += -Winline
#CPPFLAGS += -Wmissing-noreturn -Wpacked
#CPPFLAGS += -Wconversion

# Turn off printf() format strings. We use late bound FLASH and RAM format strings and this causes warnings
CPPFLAGS += -Wno-format-nonliteral -Wno-format-security

#
# End of configuration section
##############################################################################################

##############################################################################################
# Start of build support section
#

# Default is to compile more quielty.
# To show actual commands: make [options] VERBOSE=1
VERBOSE ?= 0
COLOR ?= 1
RECORD ?= 0

ifeq ($(VERBOSE),0)
QUIET := @
else
QUIET :=
endif

ifeq ($(COLOR),1)
START_BOLD=`tput bold`
END_BOLD=`tput sgr0`
NO_COLOR=`tput setaf 0`
OK_COLOR=`tput setaf 2`
ERROR_COLOR=`tput setaf 1`
WARN_COLOR=`tput setaf 3`
endif


ifeq ($(VERBOSE),2)
define NEWLINE_ONLY


endef
define NEWLINE_TAB


endef
endif

ifeq ($(RECORD),0)
REC := true #
else
REC := $(realpath ${MOTATE_PATH}/compile_recorder.js)
endif

#
# End of build support section
##############################################################################################

##############################################################################################
# Output directories (must be before BOARDs section)
#

ifeq ($(strip $(CONFIG)),)
	BIN=bin/$(BOARD)
	OBJ=build/$(BOARD)
else
	BIN=bin/$(CONFIG)-$(BOARD)
	OBJ=build/$(CONFIG)-$(BOARD)
endif
DEPDIR=$(OBJ)/dep

#
# End of Output directories
##############################################################################################

include ${MOTATE_PATH}/MotateUtilities.mk

##############################################################################################
# Start of BOARDs section
#

# Available BOARD-specific defines:
# MOTATE_CONFIG_HAS_USBSERIAL
#

# Common location for the CMSIS directory (might not be used)
CMSIS_ROOT = ${MOTATE_PATH}/cmsis

# STAR is a stupid hack to make XCode stopthinking the REST OF THE FILE
# is a comment.
STAR:=*
-include ./boards.mk
include $(wildcard ${MOTATE_PATH}/board/$(STAR).mk)

ifneq ("$(_BOARD_FOUND)", "1")

ifeq ('$(BOARD)','NONE')
# errors cannot be indented
$(error BOARD not defined - please provide a project name)
endif

# errors cannot be indented
$(error Unknown board "$(BOARD)")
endif

#
# End of BOARDs section
##############################################################################################

##############################################################################################
# Start of setup tools
#

# Output file basename
OUTPUT_BIN = $(BIN)/$(PROJECT)

# Some basical (external) utility paths
RM      = rm
CP      = cp
# NOTE: Atmel Studio will default to the wrong mkdir that doesn't understand -p.
#       So, in windows we set MKDIR=gmkdir below.
MKDIR   = mkdir
GIT     = git

SHELL = bash

SPECIAL_ATMEL_STUDIO_DEFAULT_TARGETS =

# Here we use some heuristics to find the OS.
ifneq (,$(findstring Atmel,$(PATH)))
$(info "Found that we're in Atmel Studio")
OS := WIN32
TOOLS_SUBPATH := win32/gcc-$(CROSS_COMPILE)
PATH := $(TOOLS_PATH)/$(TOOLS_SUBPATH)/bin;c:\Program Files\Git\bin;c:\Program Files\Git\cmd;c:\Program Files\Git\mingw32\bin;c:\Program Files\Git\mingw64\bin;$(PATH)
MKDIR   = gmkdir
SPECIAL_ATMEL_STUDIO_DEFAULT_TARGETS = $(PROJECT).elf $(PROJECT).map
else
ifneq (,$(findstring /cygdrive/,$(PATH)))
$(info "Found that we're in Windows Cygwin")
OS := WIN32
TOOLS_SUBPATH := win32/gcc-$(CROSS_COMPILE)
PATH := $(TOOLS_PATH)/$(TOOLS_SUBPATH)/bin;c:\Program Files\Git\bin;c:\Program Files\Git\cmd;c:\Program Files\Git\mingw32\bin;c:\Program Files\Git\mingw64\bin;$(PATH)
#MKDIR   = gmkdir
else
ifneq (,$(findstring WINDOWS,$(PATH)))
$(info "Found that we're in WINDOWS")
OS := WIN32
TOOLS_SUBPATH := win32/gcc-$(CROSS_COMPILE)
PATH := $(TOOLS_PATH)/$(TOOLS_SUBPATH)/bin;c:\Program Files\Git\bin;c:\Program Files\Git\cmd;c:\Program Files\Git\mingw32\bin;c:\Program Files\Git\mingw64\bin;$(PATH)
#MKDIR   = gmkdir
else


# Unix/Linux section:
UNAME := $(shell uname -s)

ifeq (Darwin,${UNAME})
$(info "Found that we're in OS X")
OS = OSX
TOOLS_SUBPATH := osx/gcc-$(CROSS_COMPILE)
else
ifeq (Linux,${UNAME})
$(info "Found that we're in Linux")
OS = LINUX
TOOLS_SUBPATH := linux/gcc-$(CROSS_COMPILE)
endif #LINUX
endif #Darwin


#PATH := $(TOOLS_PATH)/$(TOOLS_SUBPATH)/bin:$(PATH)

# end Unix/linux section
endif #WINDOWS
endif #cygdrive
endif #Atmel Studio

export PATH
export MOTATE_PATH

CWD = $(realpath .)

# Compilation tools - hardcode the full path to the ones we provide
ifdef TOOLCHAIN
TOOLS_FULLPATH := $(TOOLCHAIN)
else
TOOLS_FULLPATH := $(TOOLS_PATH)/$(TOOLS_SUBPATH)/bin
endif

CC      = $(TOOLS_FULLPATH)/$(CROSS_COMPILE)-gcc
CXX     = $(TOOLS_FULLPATH)/$(CROSS_COMPILE)-g++
LD      = $(TOOLS_FULLPATH)/$(CROSS_COMPILE)-ld
AR      = $(TOOLS_FULLPATH)/$(CROSS_COMPILE)-ar
SIZE    = $(TOOLS_FULLPATH)/$(CROSS_COMPILE)-size
STRIP   = $(TOOLS_FULLPATH)/$(CROSS_COMPILE)-strip
OBJCOPY = $(TOOLS_FULLPATH)/$(CROSS_COMPILE)-objcopy
GDB     = $(TOOLS_FULLPATH)/$(CROSS_COMPILE)-gdb
GDB_PY  = $(TOOLS_FULLPATH)/$(CROSS_COMPILE)-gdb-py
NM      = $(TOOLS_FULLPATH)/$(CROSS_COMPILE)-nm

ifneq ($(NOT_IN_GIT),1)
	GIT_LOCATED := $(GIT)
	GIT_VERSION := $(shell $(GIT) describe --abbrev=4 --dirty --always --tags)
	GIT_EXACT_VERSION := $(shell $(GIT) describe --abbrev=0 --tags)

	# Push the git version into the code -- the ""s must be escaped and make it into the code intact
	DEVICE_DEFINES += GIT_VERSION=\"$(GIT_VERSION)\" GIT_EXACT_VERSION=$(GIT_EXACT_VERSION)
else
   # Push the git version into the code -- the ""s must be escaped and make it into the code intact
   DEVICE_DEFINES += GIT_VERSION=\"UNKNOWN-not-from-git\" GIT_EXACT_VERSION=0.0
endif


# ---------------------------------------------------------------------------------------
# LTO generic flags

ifeq ($(USE_LTO),1)
LTO = -flto
else
LTO =
endif


# ---------------------------------------------------------------------------------------
# C Flags (NOT CPP flags)

#CFLAGS +=  $(DEVICE_CFLAGS)
CFLAGS +=  $(DEVICE_CFLAGS) -DBOARD=$(BOARD) $(LTO)

# ---------------------------------------------------------------------------------------
# CPP Flags

#CPPFLAGS +=  $(DEVICE_CPPFLAGS)
CPPFLAGS +=  $(DEVICE_CPPFLAGS) -DBOARD=$(BOARD)  $(LTO)

# ---------------------------------------------------------------------------------------
# ASM Flags

ASFLAGS = $(DEVICE_ASFLAGS)  $(LTO)

# ---------------------------------------------------------------------------------------
# Linker Flags

DEBUG_SYMBOLS = -g3

LDFLAGS += $(LIBS) $(USER_LIBS) $(DEBUG_SYMBOLS) -O$(OPTIMIZATION) -Wl,--cref -Wl,--check-sections -Wl,--gc-sections -ffunction-sections -Wl,--unresolved-symbols=report-all -Wl,--warn-common -Wl,--warn-section-align $(DEVICE_LDFLAGS)  $(LTO)
# To allow unresolved symbols, uncomment
#LDFLAGS += -Wl,--warn-unresolved-symbols

#LDFLAGS += -Wl,--relax

#
# End of setup tools
##############################################################################################

##############################################################################################
# Start of file paths setup
#

# Directories where source files can be found

C_SOURCES   = $(foreach dir,$(SOURCE_DIRS),$(sort $(wildcard $(dir)/$(STAR).c)) )
CXX_SOURCES = $(foreach dir,$(SOURCE_DIRS),$(sort $(wildcard $(dir)/$(STAR).cpp)) )
ASM_SOURCES = $(foreach dir,$(SOURCE_DIRS),$(sort $(wildcard $(dir)/$(STAR).s $(dir)/$(STAR).S)) )

C_OBJECTS   := $(addsuffix .o,$(basename $(C_SOURCES)))
CXX_OBJECTS := $(addsuffix .o,$(basename $(CXX_SOURCES)))
ASM_OBJECTS := $(addsuffix .o,$(basename $(ASM_SOURCES)))
FIRST_LINK_OBJECTS = $(addsuffix .o,$(basename $(FIRST_LINK_SOURCES)))

INCLUDES = $(patsubst %,-I%,$(DEVICE_INCLUDE_DIRS) $(USER_INCLUDE_DIRS))
LIBS     = $(patsubst %,-l%,$(DEVICE_LIBS) $(USER_LIBS))
LIBDIR   = $(patsubst %,-L%,$(DEVICE_LIB_DIRS) $(USER_LIB_DIRS))

#
# End of file paths setup
##############################################################################################

##############################################################################################
# Start of RULES
#

ifeq ($(VERBOSE),2)
$(info DEVICE_INCLUDE_DIRS+USER_INCLUDE_DIRS:$(patsubst %,$(NEWLINE_TAB)%,$(DEVICE_INCLUDE_DIRS) $(USER_INCLUDE_DIRS)))
$(info $(NEWLINE_ONLY)DEVICE_LIB_DIRS+USER_LIB_DIRS: $(patsubst %,$(NEWLINE_TAB)%,$(DEVICE_LIB_DIRS) $(USER_LIB_DIRS)))
$(info $(NEWLINE_ONLY)SOURCE_DIRS: $(patsubst %,$(NEWLINE_TAB)%,$(SOURCE_DIRS)))
$(info $(NEWLINE_ONLY)C_SOURCES: $(patsubst %,$(NEWLINE_TAB)%,$(C_SOURCES)))
$(info $(NEWLINE_ONLY)CXX_SOURCES: $(patsubst %,$(NEWLINE_TAB)%,$(CXX_SOURCES)))
$(info $(NEWLINE_ONLY)FIRST_LINK_SOURCES: $(patsubst %,$(NEWLINE_TAB)%,$(FIRST_LINK_SOURCES)))
endif

ifneq ("$(DEVICE_NEEDS_HEX)","")
NEEDS_HEX = $(OUTPUT_BIN).hex
endif

all: $(OUTPUT_BIN).elf $(NEEDS_HEX) $(SPECIAL_ATMEL_STUDIO_DEFAULT_TARGETS)
	@echo $(START_BOLD)Build ${GIT_EXACT_VERSION} "${GIT_VERSION}"$(END_BOLD)

$(eval $(DEVICE_RULES))

# We use tools as a "macro" for dependencies later
tools: | $(TOOLS_PATH)/$(TOOLS_SUBPATH)/bin

$(TOOLS_PATH)/$(TOOLS_SUBPATH)/bin:
ifdef TOOLCHAIN
	@echo Using provided toolchain
	mkdir -p "$(TOOLS_PATH)/$(TOOLS_SUBPATH)/bin"
	@echo Compiler is $(CXX)
else
	@echo Installing the necessary tools...
	cd ${TOOLS_PATH} && make "ARCH=gcc-${CROSS_COMPILE}"
endif

OUTDIR = $(OBJ)

FIRST_LINK_OBJECTS_PATHS := $(addprefix $(OUTDIR)/,$(subst $(MOTATE_PATH),motate,$(FIRST_LINK_OBJECTS)))

MOTATE_C_OBJECTS   := $(addprefix $(OUTDIR)/,$(subst $(MOTATE_PATH),motate,$(filter $(MOTATE_PATH)/%,$(C_OBJECTS))))
MOTATE_CXX_OBJECTS := $(addprefix $(OUTDIR)/,$(subst $(MOTATE_PATH),motate,$(filter $(MOTATE_PATH)/%,$(CXX_OBJECTS))))
MOTATE_ASM_OBJECTS := $(addprefix $(OUTDIR)/,$(subst $(MOTATE_PATH),motate,$(filter $(MOTATE_PATH)/%,$(ASM_OBJECTS))))

ALL_OTHER_C_OBJECTS   := $(addprefix $(OUTDIR)/,$(filter-out $(MOTATE_PATH)/%,$(C_OBJECTS)))
ALL_OTHER_CXX_OBJECTS := $(addprefix $(OUTDIR)/,$(filter-out $(MOTATE_PATH)/%,$(CXX_OBJECTS)))
ALL_OTHER_ASM_OBJECTS := $(addprefix $(OUTDIR)/,$(filter-out $(MOTATE_PATH)/%,$(ASM_OBJECTS)))

ALL_C_OBJECTS   := $(MOTATE_C_OBJECTS) $(ALL_OTHER_C_OBJECTS)
ALL_CXX_OBJECTS := $(MOTATE_CXX_OBJECTS) $(ALL_OTHER_CXX_OBJECTS)
ALL_ASM_OBJECTS := $(MOTATE_ASM_OBJECTS) $(ALL_OTHER_ASM_OBJECTS)


#
CFLAGS   += $(DEBUG_SYMBOLS) -O$(OPTIMIZATION) $(INCLUDES) $(patsubst %,-D%,$(DEVICE_DEFINES) $(USER_DEFINES))
CPPFLAGS += $(DEBUG_SYMBOLS) -O$(OPTIMIZATION) $(INCLUDES) $(patsubst %,-D%,$(DEVICE_DEFINES) $(USER_DEFINES))
ASFLAGS  += $(DEBUG_SYMBOLS) -O$(OPTIMIZATION) $(INCLUDES) -D__ASSEMBLY__ $(patsubst %,-D%,$(DEVICE_DEFINES) $(USER_DEFINES))

ifneq ("$(DEVICE_LINKER_SCRIPT)", "")
LINKER_SCRIPT := $(DEVICE_LINKER_SCRIPT)
LINKER_SCRIPT_TEXT = $(LINKER_SCRIPT)
LINKER_SCRIPT_OPTION = -T"$(LINKER_SCRIPT)"

else

ABS_LINKER_SCRIPT =
ABS_LINKER_SCRIPT_TEXT = "[built in]"
LINKER_SCRIPT_OPTION =

endif

# Generate dependency information
DEPFLAGS = -MMD -MF $(OBJ)/dep/$(@F).d -MT $(subst $(OUTDIR),$(OBJ),$@)

$(OUTPUT_BIN).elf: $(ALL_C_OBJECTS) $(ALL_CXX_OBJECTS) $(ALL_ASM_OBJECTS) $(LINKER_SCRIPT)
	@echo $(START_BOLD)"Linking $(OUTPUT_BIN).elf" $(END_BOLD)
	@echo $(START_BOLD)"Using linker script: $(LINKER_SCRIPT)" $(END_BOLD)
	$(QUIET)$(CXX) $(LIB_PATH) $(LINKER_SCRIPT_OPTION) $(LIBDIR) -Wl,-Map,"$(OUTPUT_BIN).map" -o ${filter-out tools,$@} $(LDFLAGS) $(LD_OPTIONAL) -Wl,--start-group $(FIRST_LINK_OBJECTS_PATHS) $(filter-out $(FIRST_LINK_OBJECTS_PATHS) $(LINKER_SCRIPT) tools,$+) $(LIBS) -Wl,--end-group
	@echo $(START_BOLD)"Exporting symbols $(OUTPUT_BIN).elf.txt" $(END_BOLD)
	$(QUIET)$(NM) "$(OUTPUT_BIN).elf" >"$(OUTPUT_BIN).elf.txt"
	@echo $(START_BOLD)"Making binary $(OUTPUT_BIN).bin" $(END_BOLD)
	$(QUIET)$(OBJCOPY) -O binary "$(OUTPUT_BIN).elf" "$(OUTPUT_BIN).bin"
	@echo "--- SIZE INFO ---"
	$(QUIET)$(SIZE) "$(OUTPUT_BIN).elf"

$(OUTPUT_BIN).hex: $(OUTPUT_BIN).elf
	$(QUIET)$(OBJCOPY) -O ihex $(DEVICE_HEX_FLAGS) $< $@

## Note: The motate paths are seperated due to MOTATE_PATH having multple ../ in it.

$(MOTATE_CXX_OBJECTS): | tools $(sort $(dir $(MOTATE_CXX_OBJECTS))) $(DEPDIR) $(BIN)
$(MOTATE_CXX_OBJECTS): $(OUTDIR)/motate/%.o: $(MOTATE_PATH)/%.cpp
	@echo $(START_BOLD)"Compiling cpp $<"; echo "    -> $@" $(END_BOLD)
	@cd $(MOTATE_PATH) && $(REC) $(CWD) $(realpath $<) $(realpath $(CXX)) $(subst $(MOTATE_PATH),$(realpath $(MOTATE_PATH)),$(INCLUDES) $(patsubst %,-D%,$(DEVICE_DEFINES) $(USER_DEFINES))) -xc++ -c -o $(realpath $@) $(realpath $<)
	$(QUIET)$(CXX) $(CPPFLAGS) $(DEPFLAGS) -xc++ -c -o $@ $<

$(ALL_OTHER_CXX_OBJECTS): | tools $(sort $(dir $(ALL_OTHER_CXX_OBJECTS))) $(DEPDIR) $(BIN)
$(ALL_OTHER_CXX_OBJECTS): $(OUTDIR)/%.o: %.cpp
	@echo $(START_BOLD)"Compiling cpp $<"; echo "    -> $@" $(END_BOLD)
	@$(REC) $(CWD) $(realpath $<) $(realpath $(CXX)) $(INCLUDES) $(patsubst %,-D%,$(DEVICE_DEFINES) $(USER_DEFINES)) -xc++ -c -o $@ $<
	$(QUIET)$(CXX) $(CPPFLAGS) $(DEPFLAGS) -xc++ -c -o $@ $<

$(MOTATE_C_OBJECTS): | tools $(sort $(dir $(MOTATE_C_OBJECTS))) $(DEPDIR) $(BIN)
$(MOTATE_C_OBJECTS): $(OUTDIR)/motate/%.o: $(MOTATE_PATH)/%.c
	@echo $(START_BOLD)"Compiling c $<"; echo "    -> $@" $(END_BOLD)
	@cd $(MOTATE_PATH) && $(REC) $(CWD) $(realpath $<) $(realpath $(CC)) $(subst $(MOTATE_PATH),$(realpath $(MOTATE_PATH)),$(INCLUDES) $(patsubst %,-D%,$(DEVICE_DEFINES) $(USER_DEFINES))) -c -o $(realpath $@) $(realpath $<)
	$(QUIET)$(CC) $(CFLAGS) $(DEPFLAGS) -c -o $@ $<

$(ALL_OTHER_C_OBJECTS): | tools $(sort $(dir $(ALL_OTHER_C_OBJECTS))) $(DEPDIR) $(BIN)
$(ALL_OTHER_C_OBJECTS): $(OUTDIR)/%.o: %.c
	@echo $(START_BOLD)"Compiling c $<"; echo "    -> $@" $(END_BOLD)
	@$(REC) $(CWD) $(realpath $<) $(realpath $(CC)) $(INCLUDES) $(patsubst %,-D%,$(DEVICE_DEFINES) $(USER_DEFINES)) -c -o $@ $<
	$(QUIET)$(CC) $(CFLAGS) $(DEPFLAGS) -c -o $@ $<

$(MOTATE_ASM_OBJECTS): | tools $(sort $(dir $(MOTATE_ASM_OBJECTS))) $(DEPDIR) $(BIN)
$(MOTATE_ASM_OBJECTS): $(OUTDIR)/motate/%.o: $(MOTATE_PATH)/%.s
	@echo $(START_BOLD)"Compiling $<"; echo "    -> $@"  $(END_BOLD)
	@cd $(MOTATE_PATH) && $(REC) $(CWD) $(realpath $<) $(realpath $(CC)) $(subst $(MOTATE_PATH),$(realpath $(MOTATE_PATH)),$(INCLUDES) $(patsubst %,-D%,$(DEVICE_DEFINES) $(USER_DEFINES))) -c -o $(realpath $@) $(realpath $<)
	$(QUIET)$(CC) $(ASFLAGS) $(DEPFLAGS) -c -o $@ $<

$(ALL_OTHER_ASM_OBJECTS): | tools $(sort $(dir $(ALL_OTHER_ASM_OBJECTS))) $(DEPDIR) $(BIN)
$(ALL_OTHER_ASM_OBJECTS): $(OUTDIR)/%.o: %.s
	@echo $(START_BOLD)"Compiling $<"; echo "    -> $@"  $(END_BOLD)
	@$(REC) $(CWD) $(realpath $<) $(realpath $(CC)) $(INCLUDES) $(patsubst %,-D%,$(DEVICE_DEFINES) $(USER_DEFINES)) -c -o $(realpath $@) $(realpath $<)
	$(QUIET)$(CC) $(ASFLAGS) $(DEPFLAGS) -c -o $@ $<



# Rules to make the directories:
$(sort $(dir $(MOTATE_CXX_OBJECTS) $(ALL_OTHER_CXX_OBJECTS) $(MOTATE_C_OBJECTS))):
	$(QUIET)$(MKDIR) -p "$@"

$(sort $(dir $(ALL_OTHER_C_OBJECTS) $(MOTATE_ASM_OBJECTS) $(ALL_OTHER_ASM_OBJECTS))):
	$(QUIET)$(MKDIR) -p "$@"

$(DEPDIR) $(BIN):
	$(QUIET)$(MKDIR) -p "$@"


# Rule for debugging
debug: $(OUTPUT_BIN).elf
	$(GDB) -ex "dir '${MOTATE_PATH}/arch/'" -x "${BOARD_PATH}.gdb" -ex "monitor reset halt" -readnow -se "$(OUTPUT_BIN).elf"

# Rule for debugging (using python-enabled debugger)
debuggy: $(OUTPUT_BIN).elf
	$(GDB_PY) -ex "dir '${MOTATE_PATH}/arch/'" -x "${BOARD_PATH}.gdb" -ex "monitor reset halt" -readnow -se "$(OUTPUT_BIN).elf"

flash: $(FLASH_REQUIRES)
	$(DEVICE_FLASH_CMD)

#-------------------------------------------------------------------------------
#		Default $(PROJECT).elf, and clean
#-------------------------------------------------------------------------------

$(PROJECT).elf: $(OUTPUT_BIN).elf
	$(CP) $< $@

$(PROJECT).map: $(OUTPUT_BIN).map
	$(CP) $< $@

$(PROJECT).hex: $(OUTPUT_BIN).elf
	$(QUIET)$(OBJCOPY) -O ihex $(DEVICE_HEX_FLAGS) $< $@

$(PROJECT).bin: $(OUTPUT_BIN).elf
	$(QUIET)$(OBJCOPY) -O binary $< $@

clean:
	-$(RM) -fR $(OBJ)
	-$(RM) -fR $(BIN)
	-$(RM) -fR $(BOARD).elf $(BOARD).map $(BOARD).hex $(BOARD).bin
	-$(RM) -fR compile_commands.json $(MOTATE_PATH)/compile_commands.json


#
# Include the dependency files, should be the last of the makefile
#
-include $(shell mkdir $(OBJ)/dep 2>/dev/null) $(wildcard $(OBJ)/dep/*.d)

#
# End of RULES
##############################################################################################

# *** EOF ***
