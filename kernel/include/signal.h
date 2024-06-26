#ifndef __SIGNAL_H
#define __SIGNAL_H
#include "types.h"

#define SIGHUP     1    // Hangup
#define SIGINT     2    // Interrupt
#define SIGQUIT    3    // Quit
#define SIGILL     4    // Illegal instruction
#define SIGTRAP    5    // Trace trap
#define SIGABRT    6    // Abort (abort)
#define SIGIOT     6    // IOT trap (on some systems)
#define SIGBUS     7    // BUS error (bad memory access)
#define SIGFPE     8    // Floating-point exception
#define SIGKILL    9    // Kill, unblockable
#define SIGUSR1    10   // User-defined signal 1
#define SIGSEGV    11   // Segmentation violation (invalid memory reference)
#define SIGUSR2    12   // User-defined signal 2
#define SIGPIPE    13   // Broken pipe: write to pipe with no readers
#define SIGALRM    14   // Timer signal from alarm(2)
#define SIGTERM    15   // Termination signal
#define SIGSTKFLT  16   // Stack fault on coprocessor (unused)
#define SIGCHLD    17   // Child stopped or terminated
#define SIGCONT    18   // Continue if stopped
#define SIGSTOP    19   // Stop process unblockable
#define SIGTSTP    20   // Keyboard stop
#define SIGTTIN    21   // Background read from tty
#define SIGTTOU    22   // Background write to tty
#define SIGURG     23   // Urgent condition on socket (4.2BSD)
#define SIGXCPU    24   // CPU limit exceeded (4.2BSD)
#define SIGXFSZ    25   // File size limit exceeded (4.2BSD)
#define SIGVTALRM  26   // Virtual alarm clock (4.2BSD)
#define SIGPROF    27   // Profiling alarm clock (4.2BSD)
#define SIGWINCH   28   // Window size change (4.3BSD, Sun)
#define SIGIO      29   // I/O now possible (4.2BSD)
#define SIGPOLL    SIGIO // Pollable event occurred (System V)
#define SIGPWR     30   // Power failure restart (System V)
#define SIGSYS     31   // Bad system call

// Real-time signals
#define SIGRTMIN   32   // First real-time signal
#define SIGRTMAX   64   // Last real-time signal

// Signal Flags
#define SA_NOCLDSTOP	0x00000001
#define SA_NOCLDWAIT	0x00000002
#define SA_NODEFER		0x08000000
#define SA_RESETHAND	0x80000000
#define SA_RESTART		0x10000000
#define SA_SIGINFO		0x00000004

// Flags for sigprocmask 
#define SIG_BLOCK 		0
#define SIG_UNBLOCK 	1
#define SIG_SETMASK		2

typedef void (*__sighandler_t)(int);

#define SIGSET_LEN 		1
typedef struct {
	unsigned long __val[SIGSET_LEN];
} __sigset_t;

typedef struct sigaction {
	union {		// let's make it simple, only sa_handler is supported 
		__sighandler_t sa_handler;
		// void (*sa_sigaction)(int, siginfo_t *, void *);
	} __sigaction_handler;
	__sigset_t sa_mask;	// signals to be blocked during handling 
	int sa_flags;
	// void (*sa_restorer)(void);	// this field is not used on risc-v
}sigaction;



int set_sigaction(int signum, sigaction const *act, sigaction *oldact);

int sigprocmask(int how, __sigset_t *set, __sigset_t *oldset);
uint64 rt_sigreturn(void);
void sighandle(void);
#endif