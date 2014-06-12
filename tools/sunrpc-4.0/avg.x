/*
 * The average procedure receives an array of real
 * numbers and returns the average of their
 * values. This toy service handles a maximum of
 * 200 numbers.
 */
const MAXAVGSIZE  = 200

struct input_data {
	double input_data<>;
};

struct output_data {
	double output_data<>;
};

typedef struct input_data input_data;

program AVERAGEPROG {
    version AVERAGEVERS {
        double AVERAGE(input_data) = 1;
        output_data MYCOPY(input_data) = 2;

    } = 1;
} = 22855;

