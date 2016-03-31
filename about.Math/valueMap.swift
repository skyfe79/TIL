

// convert ofMap function to swift version
func valueMap(value value : CGFloat, inputMin : CGFloat, inputMax : CGFloat, outputMin : CGFloat, outputMax : CGFloat, clamp : Bool = true) -> CGFloat {
        
    if (fabs(inputMin - inputMax) < CGFloat(FLT_EPSILON)){
        
        return outputMin;
        
    } else {
     
        var outVal : CGFloat = ((value - inputMin) / (inputMax - inputMin) * (outputMax - outputMin) + outputMin);
        
        if clamp {
            if outputMax < outputMin {
                
                if outVal < outputMax {
                    outVal = outputMax;
                }
                else if outVal > outputMin {
                    outVal = outputMin;
                }
                
            } else {
                
                if outVal > outputMax {
                    outVal = outputMax;
                }
                else if outVal < outputMin {
                    outVal = outputMin;
                }
            }
        }
        return outVal;
    }
}
