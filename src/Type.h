#ifndef __LOLIROFLE_TCALC_TYPE_H_INCLUDED__
#define __LOLIROFLE_TCALC_TYPE_H_INCLUDED__

struct Type{
	Stringp name;
	void(*print)(void* data);
};

#endif
