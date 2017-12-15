

#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){
    ofSetBackgroundColorHex(0x000000);
    
    //My Circles
    ofSetCircleResolution(100);
    ofSetColor(255, 255, 255);
    ofNoFill();
    ofSetLineWidth(2);
    ofSetColor(89, 251, 218);
    
    markerI.set(0,0);
    markerII.set(0,0);
    
    //for some reason on the iphone simulator 256 doesn't work - it comes in as 512!
    //so we do 512 - otherwise we crash
    initialBufferSize = 512;
    sampleRate = 44100;
    drawCounter = 0;
    bufferCounter = outCounter = 0;
    
    buffer = new float[initialBufferSize];
    memset(buffer, 0, initialBufferSize * sizeof(float));
    
    // 0 output channels,
    // 1 input channels
    // 44100 samples per second
    // 512 samples per buffer
    // 1 buffer
    // ofxiOSSoundStream::setMixWithOtherApps(true);
    
    ofSoundStreamSetup(2, 1, this, sampleRate, initialBufferSize, 1);
    
    recording=playing=false;
    playhead=0;
}

//--------------------------------------------------------------
void ofApp::update(){
    
}
//--------------------------------------------------------------
void ofApp::audioIn(float * input, int bufferSize, int nChannels){
    if(initialBufferSize < bufferSize){
        ofLog(OF_LOG_ERROR, "your buffer size was set to %i - but the stream needs a buffer size of %i", initialBufferSize, bufferSize);
    }
    
    int minBufferSize = MIN(initialBufferSize, bufferSize);
    for(int i=0; i<minBufferSize; i++) {
        buffer[i] = input[i];
        if(recording) sample.push_back(buffer[i]);
    }
    bufferCounter++;
}

//--------------------------------------------------------------
void ofApp::audioOut(float * output, int bufferSize, int nChannels) {
    if( initialBufferSize < bufferSize ){
        ofLog(OF_LOG_ERROR, "your buffer size was set to %i - but the stream needs a buffer size of %i", initialBufferSize, bufferSize);
        return;
    }
    if(playing){
        outCounter++;
        
        for (int i = 0; i < bufferSize; i++){
            float currentSample;
            if(sample.size() > 0){
                currentSample = sample[playhead];
            }
            output[i*nChannels] =currentSample;
            output[i*nChannels + 1] =currentSample;
            playhead++;
            //cout << "playhead" << playhead << endl;
            if(playhead >= sample.size()){
                playhead = 0;
            }
        }
    }else{
        for (int i = 0; i < bufferSize; i++){
            output[i*nChannels] =0;
            output[i*nChannels + 1] =0;
        }
    }
}


//--------------------------------------------------------------
void ofApp::checkObject(ofTouchEventArgs & touch)
{
    if(touch.id == 0)
    {
        markerI.set(touch.x,touch.y);
    }
    
    if(touch.id == 1)
    {
        markerII.set(touch.x, touch.y);
        
        dist = ofDist(markerI.x, markerI.y, markerII.x, markerII.y);
        
        if(dist > 140 && dist < 170)
        {
            workingMode = true;
            
            if (markerI.x < markerII.x)
            {
                diffX = markerI.x+(markerII.x - markerI.x)/2;
            }
            else
            {
                diffX = markerII.x+(markerI.x - markerII.x)/2;
            }
            
            if (markerI.y < markerII.y)
            {
                diffY = markerI.y+(markerII.y - markerI.y)/2;
            }
            else
            {
                diffY = markerII.y+(markerI.y - markerII.y)/2;
            }
        }
    }
}
//--------------------------------------------------------------
void ofApp:: createMenu()
{
    if(workingMode == true)
    {
        ofDrawEllipse(diffX,diffY, 600, 600);
        ofDrawEllipse(diffX,diffY+220, 80,80);
        
        if(saffer == true)
        {
            ofFill();
            ofSetColor(89, 251, 218, 100);
            ofDrawEllipse(diffX,diffY+220, 80,80);
            ofSetColor(255, 255, 255);
            ofNoFill();
            ofSetLineWidth(2);
            ofSetColor(89, 251, 218);
        }
        if(audioStored == true)
        {
            
            ofDrawEllipse(diffX,diffY-220, 80,80);
            ofFill();
            //            ofSetColor(89, 251, 218, 100);
            //            ofDrawEllipse(diffX,diffY-220, 80,80);
            ofDrawTriangle(diffX-10, diffY-220+20, diffX-10, diffY-220-20, diffX+20, diffY-220);
            ofNoFill();
            ofSetColor(89, 251, 218);
            
            if(playPressed == true)
            {
                ofFill();
                ofSetColor(89, 251, 218);
                ofDrawEllipse(diffX,diffY-220, 80,80);
                ofSetColor(0,0,0);
                ofDrawRectangle(diffX-20, diffY-240, 40, 40);
                //ofDrawTriangle(diffX-10, diffY-220+20, diffX-10, diffY-220-20, diffX+20, diffY-220);
                ofNoFill();
                ofSetColor(89, 251, 218);
                
                stopBtn = true;
            }
        }
    }
}
//--------------------------------------------------------------
void ofApp::draw()
{
    createMenu();
    ofDrawBitmapString(ofToString(outCounter), 10, 10);
    ofDrawBitmapString(ofToString(bufferCounter), 10, 30);
}
//--------------------------------------------------------------
void ofApp::exit(){
    
}
//--------------------------------------------------------------
void ofApp::touchDown(ofTouchEventArgs & touch)
{
    checkObject(touch);
    
    if(touch.x < diffX+40 && touch.y < diffY+260 && touch.x > diffX-40 && touch.y > diffY+220 )
    {
        saffer = true;
        
        //RECORD
        sample.clear();
        recording=true;
        //cout << "recording" << recording << endl;
    }
}

//--------------------------------------------------------------
void ofApp::touchMoved(ofTouchEventArgs & touch){
    
    checkObject(touch);
    
}
//--------------------------------------------------------------
void ofApp::touchUp(ofTouchEventArgs & touch){
    
    //workingMode = false;
    
    if(touch.x < diffX+40 && touch.y < diffY+260 && touch.x > diffX-40 && touch.y > diffY+220)
    {
        saffer = false;
        audioStored = true;
        workingMode = false;
        
        //stop recording
        recording = false;
        //cout << "STOPrecording" << recording << endl;
    }
    if(touch.x < diffX+40 && touch.y < diffY-220 && touch.x > diffX-40 && touch.y > diffY-260)
    {
        playing=!playing;
        playPressed=!playPressed;
        cout << "playing" << playing << endl;
        if(!playing){
            playhead=outCounter=0;
        }
        //
        //        if(stopBtn == false)
        //        {
        //            playPressed = true;
        //
        //
        //            //PLAY AUDIO
        //            playing = true;
        //            cout << "playing" << playing << endl;
        //
        //        }
        //        if(stopBtn == true)
        //        {
        //            playPressed = false;
        //            stopBtn = false;
        //
        //            //STOP AUDIO
        //            playing=false;
        //            sample.clear();
        //            playhead=outCounter=0;
        //            cout << "stop" << endl;
        //        }
    }
}

//--------------------------------------------------------------
void ofApp::touchDoubleTap(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void ofApp::touchCancelled(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void ofApp::lostFocus(){
    
}
//c
//--------------------------------------------------------------
void ofApp::gotFocus(){
    
}

//--------------------------------------------------------------
void ofApp::gotMemoryWarning(){
    
}

//--------------------------------------------------------------
void ofApp::deviceOrientationChanged(int newOrientation){
    
}

