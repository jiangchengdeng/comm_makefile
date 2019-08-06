
TARGET := test
 
CC := gcc
 
#ע��ÿ�к��治Ҫ�пո񣬷�����㵽Ŀ¼�����棬��������
SRC_DIR = .
SRC_DIR += src

#�����������ͷ�ļ�·��
INC_DIR = \
	-I ./include \
	-I ./src \
	-I ./src/include

#������ӱ������
CC_FLAGS := $(INC_DIR) -g 
LNK_FLAGS := \



BUILD_DIR = build
OBJ_DIR = $(BUILD_DIR)/obj
DEPS_DIR  = $(BUILD_DIR)/deps
 
 
#����ݹ����3����Ŀ¼
#DIRS := $(shell find $(SRC_DIR) -maxdepth 3 -type d)
 
#��ÿ����Ŀ¼��ӵ�����·��
#VPATH = $(DIRS)

#����src_dir���������Ŀ¼������c�ļ�
SOURCES   = $(foreach dir, $(SRC_DIR), $(wildcard $(dir)/*.c)) 
OBJS   = $(addprefix $(OBJ_DIR)/,$(patsubst %.c,%.o, $(SOURCES))) 
DEPS  = $(addprefix $(DEPS_DIR)/, $(patsubst %.c,%.d, $(SOURCES))) 

$(TARGET):$(OBJS)
	$(CC) $^ $(LNK_FLAGS) -o $@

#����֮ǰҪ����OBJĿ¼��ȷ��Ŀ¼����
$(OBJ_DIR)/%.o:%.c
	$(foreach dir, $(SRC_DIR), if [ ! -d $(OBJ_DIR)/$(dir) ]; then mkdir -p $(OBJ_DIR)/$(dir); fi;)\
	$(CC) -c $(CC_FLAGS) $< -o $@
 
#����֮ǰҪ����DEPSĿ¼��ȷ��Ŀ¼����
#ǰ���@��ʾ���������ִ�д�ӡ
$(DEPS_DIR)/%.d:%.c
	@$(foreach dir, $(SRC_DIR), if [ ! -d $(DEPS_DIR)/$(dir) ]; then mkdir -p $(DEPS_DIR)/$(dir); fi;)\
	set -e; rm -f $@;\
	$(CC) -MM $(CC_FLAGS) $< > $@.$$$$;\
	sed 's,\($*\)\.o[ :]*,$(OBJ_DIR)/\1.o $@ : ,g' < $@.$$$$ > $@;\
	rm -f $@.$$$$
 
#ǰ���-��ʾ���Դ���
-include $(DEPS)
 
.PHONY : clean
clean:
	rm -rf $(OBJS) $(DEPS) $(TARGET)
