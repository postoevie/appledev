
Core ML

Concept of CoreML

https://devstreaming-cdn.apple.com/videos/wwdc/2017/710vxa4hl8hyb72/710/710_core_ml_in_depth.pdf
https://devstreaming-cdn.apple.com/videos/wwdc/2017/703muvahj3880222/703/703_introducing_core_ml.pdf


Versions

https://developer.apple.com/videos/play/wwdc2019/704/


CoreML model

MLModel file is a binary containing all the data descripting machine learning model - metadata, interface (what is input and output), architecture and weights. 
Modern approach to store files is to put this content in a package.
They support all mainstream models like Neural ones, SVM, linear etc

Its possible to convert defined set of models (built with Pytorch/TF etc) with
https://apple.github.io/coremltools/docs-guides/

MLPrograms and mlmodels are created from other ML model reps like PyTorch or TF using Model Intermediate Language (MIL)
https://developer.apple.com/videos/play/tech-talks/10154/
https://developer.apple.com/videos/play/wwdc2020/10153/

WWDC21: Tune your Core ML models 

https://www.youtube.com/watch?v=g3yj9_DHrME 

CoreML represents a number of data types including strings, images, multiarray etc.

Multiarray enables client to operate multi-dimentional data. Its modern  counterpart is MLShapedArray.

NN doesnt strongly type its intermediate tensors. Compute unit that runs model infers the tensor's types after CoreML loads the model. CoreML runtime partitions network graph to sections - Apple Neur eng fiendly, gpu and cpu friendly. That defines vectors types and improves performance.

Its shown that while converting pytorch model to coreml model, its possible to choose resulting data size of a single weight(float16, float32) . With 32 bit option, Apple neural engine is not avalable .

CreateML

https://developer.apple.com/videos/play/wwdc2019/430 - Introducing the Create ML App . Trained model which recognize flower types is taken and trained more on other examples. Enumerated data domains which can the framework can be utilized.

https://developer.apple.com/videos/play/wwdc2020/10156 - Control training in Create ML with Swift - leverage the capabilities of MLJob and Combine publishers to watch a train process, metrics and handle a training result; Playgrounds allows to show training and validation results in accordance with Live View

https://developer.apple.com/videos/play/wwdc2021/10037 Build dynamic iOS apps with the Create ML framework - an example of how create regressor / classifier for  food ordering app


Application

https://developer.apple.com/documentation/CoreML/integrating-a-core-ml-model-into-your-app

https://developer.apple.com/videos/play/wwdc2022/10017/ Explore the machine learning development experience (Black-white to colorful images example)

https://developer.apple.com/videos/play/wwdc2019/228 Creating Great Apps Using Core ML and ARKit

https://www.youtube.com/watch?v=Lb89T7ybCBE&t=19s Bring your app to Siri
