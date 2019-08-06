
TARGET := test
 
CC := gcc
 
#注意每行后面不要有空格，否则会算到目录名里面，导致问题
SRC_DIR = .
SRC_DIR += src

#这里添加其他头文件路径
INC_DIR = \
	-I ./include \
	-I ./src \
	-I ./src/include

#这里添加编译参数
CC_FLAGS := $(INC_DIR) -g 
LNK_FLAGS := \



BUILD_DIR = build
OBJ_DIR = $(BUILD_DIR)/obj
DEPS_DIR  = $(BUILD_DIR)/deps
 
 
#这里递归遍历3级子目录
#DIRS := $(shell find $(SRC_DIR) -maxdepth 3 -type d)
 
#将每个子目录添加到搜索路径
#VPATH = $(DIRS)

#查找src_dir下面包含子目录的所有c文件
SOURCES   = $(foreach dir, $(SRC_DIR), $(wildcard $(dir)/*.c)) 
OBJS   = $(addprefix $(OBJ_DIR)/,$(patsubst %.c,%.o, $(SOURCES))) 
DEPS  = $(addprefix $(DEPS_DIR)/, $(patsubst %.c,%.d, $(SOURCES))) 

$(TARGET):$(OBJS)
	$(CC) $^ $(LNK_FLAGS) -o $@

#编译之前要创建OBJ目录，确保目录存在
$(OBJ_DIR)/%.o:%.c
	$(foreach dir, $(SRC_DIR), if [ ! -d $(OBJ_DIR)/$(dir) ]; then mkdir -p $(OBJ_DIR)/$(dir); fi;)\
	$(CC) -c $(CC_FLAGS) $< -o $@
 
#编译之前要创建DEPS目录，确保目录存在
#前面加@表示隐藏命令的执行打印
$(DEPS_DIR)/%.d:%.c
	@$(foreach dir, $(SRC_DIR), if [ ! -d $(DEPS_DIR)/$(dir) ]; then mkdir -p $(DEPS_DIR)/$(dir); fi;)\
	set -e; rm -f $@;\
	$(CC) -MM $(CC_FLAGS) $< > $@.$$$$;\
	sed 's,\($*\)\.o[ :]*,$(OBJ_DIR)/\1.o $@ : ,g' < $@.$$$$ > $@;\
	rm -f $@.$$$$
 
#前面加-表示忽略错误
-include $(DEPS)
 
.PHONY : clean
clean:
	rm -rf $(OBJS) $(DEPS) $(TARGET)
