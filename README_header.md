[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/rasmusbergpalm/deeplearntoolbox/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

DeepLearnToolbox
================

A Matlab toolbox for Deep Learning.

Deep Learning is a new subfield of machine learning that focuses on learning deep hierarchical models of data.
It is inspired by the human brain's apparent deep (layered, hierarchical) architecture.
A good overview of the theory of Deep Learning theory is
[Learning Deep Architectures for AI](http://www.iro.umontreal.ca/~bengioy/papers/ftml_book.pdf)

For a more informal introduction, see the following videos by Geoffrey Hinton and Andrew Ng.

* [The Next Generation of Neural Networks](http://www.youtube.com/watch?v=AyzOUbkUf3M) (Hinton, 2007)
* [Recent Developments in Deep Learning](http://www.youtube.com/watch?v=VdIURAu1-aU) (Hinton, 2010)
* [Unsupervised Feature Learning and Deep Learning](http://www.youtube.com/watch?v=ZmNOAtZIgIk) (Ng, 2011)

If you use this toolbox in your research please cite [Prediction as a candidate for learning deep hierarchical models of data](http://www2.imm.dtu.dk/pubdb/views/publication_details.php?id=6284)

```
@MASTERSTHESIS\{IMM2012-06284,
    author       = "R. B. Palm",
    title        = "Prediction as a candidate for learning deep hierarchical models of data",
    year         = "2012",
}
```

Contact: rasmusbergpalm at gmail dot com

Directories included in the toolbox
-----------------------------------

`NN/`   - A library for Feedforward Backpropagation Neural Networks

`CNN/`  - A library for Convolutional Neural Networks

`DBN/`  - A library for Deep Belief Networks

`SAE/`  - A library for Stacked Auto-Encoders

`CAE/` - A library for Convolutional Auto-Encoders

`util/` - Utility functions used by the libraries

`data/` - Data used by the examples

`tests/` - unit tests to verify toolbox is working

For references on each library check REFS.md

Setup
-----

1. Download.
2. addpath(genpath('DeepLearnToolbox'));

Known errors
------------------------------

`test_cnn_gradients_are_numerically_correct` fails on Octave because of a bug in Octave's convn implementation. See http://savannah.gnu.org/bugs/?39314

`test_example_CNN` fails in Octave for the same reason.
