#ifndef FJPYDEV_MPTOOLS_ALEPH_HH
#define FJPYDEV_MPTOOLS_ALEPH_HH

#include <string>
#include <fstream>
#include <vector>

namespace Aleph
{
	int dump(const char *fname, int nevents, bool noparts = false);

	class Particle
	{
	public:
		Particle();
		Particle(const Particle &p);
		Particle(double px, double py, double pz, double m, double q, int pwflag, double d0, double z0, int ntpc, int nitc, int nvdet);

		double 	get_px() 	{return fpx;}
		double 	get_py() 	{return fpy;}
		double 	get_pz() 	{return fpz;}
		double 	get_m() 	{return fm;}
		double 	get_q() 	{return fq;}
		int 	get_pwflag(){return fpwflag;}
		double 	get_d0() 	{return fd0;}
		double 	get_z0() 	{return fz0;}
		int 	get_ntpc() 	{return fntpc;}
		int 	get_nitc() 	{return fnitc;}
		int 	get_nvdet() {return fnvdet;}

		~Particle() {;}

		void dump() const;

	private:
		double 	fpx;
		double 	fpy;
		double 	fpz;
		double 	fm;
		double 	fq;
		int    	fpwflag;
		double 	fd0;
		double 	fz0;
		int 	fntpc;
		int 	fnitc;
		int 	fnvdet;
	};

	class Event
	{
	public:
		Event();
		Event(int run, int n, double e, int vflag, double vx, double vy, double ex, double ey);
		void reset(int run, int n, double e, int vflag, double vx, double vy, double ex, double ey);

		int 	get_run() 	{return frun;}
		int 	get_n() 	{return fn;}
		double 	get_e() 	{return fe;}
		int 	get_vflag() {return fvflag;}
		double  get_vx() 	{return fvx;}
		double  get_vy() 	{return fvy;}
		double  get_ex() 	{return fex;}
		double  get_ey() 	{return fey;}

		std::vector<Particle> get_particles() const;
		void add_particle(const Particle &p);
		void add_particle(double px, double py, double pz, double m, double q, int pwflag, double d0, double z0, int ntpc, int nitc, int nvdet);

		void clear();
		void dump(bool noparts = false) const;

		~Event() {;}

	private:
		int 	frun;
		int 	fn;
		double 	fe;
		int 	fvflag;
		double  fvx;
		double  fvy;
		double  fex;
		double  fey;

		std::vector<Particle> fparticles;
	};

	class Reader
	{
	public:
		Reader();
		Reader(const char *fname);
		void open(const char *fname);
		void reset();
		bool read_next_event();
		const Event& get_event();
		~Reader();
	private:
		std::string 	fName;
		std::ifstream 	fStream;
		Event 			fEvent;
	};


};

#endif
