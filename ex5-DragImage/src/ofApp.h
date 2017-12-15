#pragma once

#include "ofxiOS.h"

class ofApp : public ofxiOSApp {
    
    int dist;
    
public:
    void setup();
    void update();
    void draw();
    void exit();
    
    void touchDown(ofTouchEventArgs & touch);
    void touchMoved(ofTouchEventArgs & touch);
    void touchUp(ofTouchEventArgs & touch);
    void touchDoubleTap(ofTouchEventArgs & touch);
    void touchCancelled(ofTouchEventArgs & touch);
    
    void checkObject(ofTouchEventArgs & touch);
    void createMenu();
    void lostFocus();
    void gotFocus();
    void gotMemoryWarning();
    void deviceOrientationChanged(int newOrientation);
    
    ofPoint markerI;
    ofPoint markerII;
    Boolean workingMode = false;
    Boolean saffer = false;
    Boolean moveMode = false;
    Boolean audioStored = false;
    Boolean playPressed = false;
    Boolean stopBtn = false;
    Boolean UIline = false;
    
    int diffX,diffY;
    
    
    //RECORDER
    void audioIn(float * input, int bufferSize, int nChannels);
    void audioOut(float * output, int bufferSize, int nChannels);
    
    int    initialBufferSize;
    int    sampleRate;
    int    drawCounter;
    int bufferCounter, outCounter;
    float * buffer;
    
    double outputs;
    float volume;
    
    bool recording, playing;
    vector <float> sample;
    int playhead;
    
    vector <ofPoint> touches;
    ofPoint touchArray[2], touchAverage;
    
    
    //LOOP
    ofRectangle loopMe;
    void connectLoop();
    void checkTouch(ofTouchEventArgs & touch);
    
    float lineX, lineY;
    
    Boolean looped = false;
    
    Boolean lock = false;
};













/*
#pragma once

#include "ofxiOS.h"

class ofApp : public ofxiOSApp {
	
    public:
        void setup();
        void update();
        void draw();
        void exit();
	
        void touchDown(ofTouchEventArgs & touch);
        void touchMoved(ofTouchEventArgs & touch);
        void touchUp(ofTouchEventArgs & touch);
        void touchDoubleTap(ofTouchEventArgs & touch);
        void touchCancelled(ofTouchEventArgs & touch);

        void lostFocus();
        void gotFocus();
        void gotMemoryWarning();
        void deviceOrientationChanged(int newOrientation);

 
};







 ofImage catPic;
 ofPoint imagePoint;
 ofVec2f dragVector;*/


