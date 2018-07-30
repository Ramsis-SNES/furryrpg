CC=gcc
CXX=g++
RM=rm -f
CPPFLAGS=-g $(shell root-config --cflags)
LDFLAGS=-g $(shell root-config --ldflags)
LDLIBS=$(shell root-config --libs)

SRCS=fix_chsum_exhirom_48mbit.cc
OBJS=$(subst .cc,.o,$(SRCS))

all: fix_chsum_exhirom_48mbit

fix_chsum_exhirom_48mbit: $(OBJS)
	$(CXX) $(LDFLAGS) -o fix_chsum_exhirom_48mbit $(OBJS) $(LDLIBS) 

depend: .depend

.depend: $(SRCS)
	$(RM) ./.depend
	$(CXX) $(CPPFLAGS) -MM $^>>./.depend;

clean:
	$(RM) $(OBJS)

distclean: clean
	$(RM) *~ .depend

include .depend 
