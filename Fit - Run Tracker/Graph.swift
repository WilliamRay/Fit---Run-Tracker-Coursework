//
//  Graph.swift
//  CG4 Coursework
//
//  Created by William Ray on 26/02/2015.
//  Copyright (c) 2015 William Ray. All rights reserved.
//

import UIKit

class Graph: UIView {

    // MARK: - Global Variables

    private let indent: CGFloat = 10 //A global constant CGFloat that stores the indent (the gap between the edge of the view and the axes)
    private let axesIndent: CGFloat = 30 //A global constant CGFloat that stores the axesIndent (the gap between the edge of the view and the axes)
    private let markerHeight: CGFloat = 5 //A global constant CGFloat that stores the size of the marks on the axes
    private let majorStep: CGFloat = 10 //A global constant CGFloat that stores the spacing of the majorSteps
    private let minorStep: CGFloat = 2 //A global constant CGFloat that stores the spacing of the minor steps

    private var originX: CGFloat = 0 //A global variable CGFloat that stores the position of the x coord of the origin
    private var originY: CGFloat = 0 //A global variable CGFloat that stores the position of the y coord of the origin
    private var yAxisMax: CGFloat = 0 //A global variable CGFloat that stores the maximum y coord of the y axis
    private var xAxisMax: CGFloat = 0 //A global variable CGFloat that stores the maximum x coord of the y axis
    private var yAxisLength: CGFloat = 0 //A global variable CGFloat that stores the length of the y axis
    private var xAxisLength: CGFloat = 0 //A global variable CGFloat that stores the length of the x axis
    private var yScale: CGFloat = 0 //A global variable CGFloat that stores the scale of the y axis
    private var xScale: CGFloat = 0 //A global variable CGFloat that stores the scale of the x axis
    private var maxYValue: CGFloat = 0 //A global variable CGFloat that stores the maximum y of the axis

    private var values = [GraphCoordinate]() //A global array of GraphCoordinate objects

    // MARK: - Initialisation

    /**
    Called to initialise the class, sets the properties of the Graph to the passed values.
    
    :param: frame The frame rectangle for the view, measured in points.
    :param: coordinates An array of GraphCoordinates which are the values to plot onto the graph.
    */
    init(frame: CGRect, coordinates: [GraphCoordinate]) {
        values = coordinates
        super.init(frame: frame)
    }

    /**
    Uses the following parameters:
        coder: an NSCoder that is used to unarchive the class.
    */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    /**
    This method is called to draw the graph.
    (Note: (0, 0) is the TOP left corner)
    IF there are coordinates
        1. Set the originX to the axesIndent
        2. Set the originY to the rect height - axesIndent
        3. Set the yAxis max to the value of indent
        4. Set the xAxis max to the rect width - indent
        5. Set the yAxisLength as the originY - yAxisMax
        6. Set the xAxisLength as the rect width - axesIndent - indent
        7. Set the xScale to the xAxisLength divide the number of coordinates - 1 (since the line graph starts at the origin)
        8. Call the function getYScale
        9. Call the function plotLineGraph (so that the axes appear on top of the line)
       10. Retrieve the current graphics context and stores a reference to it (this is used to draw)
       11. Set the stroke colour for the current context to black
       12. Set the line width for the current context to 2
       13. Move to the origin
       14. Add a line to the top of the yAxis
       15. FOR markerNo from 0 to the number of major steps in the yAxis
            a. Calculate the yCoordinate of the yMarker as the yScale * majorStep * markerNumber
            b. Move to the start of the marker on the yAxis
            c. Add line from the yAxis to the end of the marker
            d. Add the text label for the marker
       16. Tells the system to draw the currently queued lines
       17. Change the line width of the currentContext to 0.4
       18. FOR markerNo from 0 to the number of minor steps in the yAxis
            e. Calculate the yCoordinate of the yMarker as the yScale * minor * markerNumber
            f. Move to the start of the marker on the yAxis
            g. Add line from the yAxis to the end of the marker
       19. Tells the system to draw the currently queued lines
       20. Change the line width of the currentContext to 2
       21. Move to the origin
       22. Add a line to the end of the xAxis
       23. FOR markerNo from 0 to the number of coordinates - 1
            h. Calculate the xCoordinate of the xMarker as the xScale * markerNo
            i. Move to the start of the marker on the xAxis
            j. Draw a line from the xAxis to the end of the marker
            k. Add the text label for the marker
       24. Tells the system to draw the currently queued lines
    
    Uses the following local variables:
        currentContext - A constant that stores the current graphics context as a CGContext.
        markerNo - An integer variable that stores the current marker number.
        yMarkerY - An integer constant that stores the y coordinate of the current y marker.
        xMarkerX - An integer constant that stores the x coordinate of the current x marker.
    
    :param: rect A CGRect that is the portion of the view’s bounds that needs to be updated.
    */
    override func draw(_ rect: CGRect) {
        if values.count > 0 {
            originX = axesIndent //1
            originY = rect.height - axesIndent //2
            yAxisMax = indent //3
            xAxisMax = rect.width - indent //4
            yAxisLength = originY - yAxisMax //5
            xAxisLength = rect.width - axesIndent - indent //6
            xScale = xAxisLength/CGFloat(values.count - 1) //7

            getYScale() //8
            plotLineGraph() //9

            let currentContext = UIGraphicsGetCurrentContext() //10
            currentContext!.setStrokeColor(UIColor.black.cgColor) //11
            currentContext!.setLineWidth(2)

            //Draw Axes
            //Y
            currentContext!.move(to: CGPoint.init(x: originX, y: originY))
            currentContext!.addLine(to: CGPoint.init(x: originX, y: originY))

            for markerNo in 0...Int(maxYValue/majorStep) { //15  -  MAJOR MARKERS
                let yMarkerY = yScale * majorStep * CGFloat(markerNo) //a
                currentContext!.move(to: CGPoint.init(x: originX, y: originY - yMarkerY))
                currentContext!.addLine(to: CGPoint.init(x: originX - markerHeight, y: originY - yMarkerY))
                self.addTextToGraph(text: self.yAxisLabel(markerNo: markerNo), xCoord: originX - 20, yCoord: originY - yMarkerY - 5) //d
            }
            currentContext!.strokePath() //16
            currentContext!.setLineWidth(0.4) //17
            for markerNo in 0...Int(maxYValue/minorStep) { //18  -  2 MARKERS
                let yMarkerY = yScale * minorStep * CGFloat(markerNo) //e
                currentContext!.move(to: CGPoint.init(x: originX, y: originY - yMarkerY))
                currentContext!.addLine(to: CGPoint.init(x: originX - markerHeight, y: originY - yMarkerY))
            }
            currentContext!.strokePath() //19
            currentContext!.setLineWidth(2) //20

            //X
            currentContext!.move(to: CGPoint.init(x: originX, y: originY))
            currentContext!.addLine(to: CGPoint.init(x: xAxisMax, y: originY))

            for markerNo in 0...values.count - 1 { //23
                let xMarkerX = xScale * CGFloat(markerNo) //h
                currentContext!.move(to: CGPoint.init(x: originX + xMarkerX, y: originY))
                currentContext!.addLine(to: CGPoint.init(x: originX + xMarkerX, y: originY + markerHeight))
                self.addXAxisTextToGraph(text: self.values[markerNo].x, xCoord: originX + xMarkerX, yCoord: originY + 60) //k
            }

            currentContext!.strokePath() //24
        }
    }

    /**
    This method draws the line for the graph
    1. Retrieve the current graphics context and stores a reference to it (this is used to draw)
    2. Set the line width for the current context to 2
    3. Set the stroke colour for the current context to red
    4. Move to the coordinate of the first point
    5. FOR pointNo from 1 to one less than the number of coordinates
        a. Draw a line to the next coordinate
    6. Tells the system to draw the currently queued lines
    
    Uses the following local variables:
        currentContext - A constant that stores the current graphics context as a CGContext.
        pointNo - An integer variable that stores the current index of the point being plotted.
    */
    func plotLineGraph() {
        let currentContext = UIGraphicsGetCurrentContext() //1
        currentContext!.setLineWidth(2) //2
        currentContext!.setStrokeColor(UIColor.red.cgColor) //3

        currentContext!.move(to: CGPoint(x: originX, y: originY - (values[0].y * yScale)))
        for pointNo in 1...values.count - 1 { //5
            currentContext!.addLine(to: CGPoint(x: (CGFloat(pointNo) * xScale) + originX, y: originY - (values[pointNo].y * yScale)))
        }
        currentContext!.strokePath() //6
    }

    /**
    This method calculates the scale to use for the yAxis
    1. Declares the local CGFloat yInterval which stores the yScale (the default is 10)
    2. Declares the local CGFloat maxYCoord that stores the maxYCoord of the data
    3. FOR each coordinate in the array values
        a. IF the coordinate y is greater than the maxYCoord
            i. Set the maxYCoord of the yCoord of the coordinate
    4. Declares the local CGFloat maxYValue that stores the max value for the y axis
    5. IF the maxYCoord modulus the major step is not 0
        b. Round the maxYCoord up to the nearest 10 and set it as the maxYValue
    6. ELSE
        c. Set the maxYValue as the maxYCoord
    7. IF the maxYValue is not 0
        d. Set the yScale as the yAxisLength dive the maxYValue
    8. Set the global yScale as the yScale
    9. Set the maxYCoord as the maxYValue
    
    Uses the following local variables:
        yScale - A variable CGFloat that stores the scale to use on the y axis
        maxYCoord - A variable CGFloat that stores the maximum y coordinate in the array of values
        coordinate - A constant GraphCoordinate that stores the current graph coordinate from the array of values
        maxYValue - A variable CGFloat that stores the maximum value on the y axis (this is either then maxYCoord if it is a multiple of 10, or the next 10 to the maxYCoord rounded up)
    */
    func getYScale() {
        var yScale: CGFloat = 10.0 //1
        var maxYCoord: CGFloat = 0.0 //2
        for coordinate in values { //3
            if coordinate.y > maxYCoord { //a
                maxYCoord = coordinate.y //i
            }
        }

        var maxYValue: CGFloat = 0.0 //4

        if maxYCoord.truncatingRemainder(dividingBy: majorStep) != 0 { //5
            maxYValue = (majorStep - (maxYCoord.truncatingRemainder(dividingBy: majorStep))) + maxYCoord //b
        } else { //6
            maxYValue = maxYCoord //c
        }

        if maxYValue != 0 { //7
            yScale = CGFloat(yAxisLength / (maxYValue)) //d
        }

        self.yScale = yScale //8
        self.maxYValue = maxYValue //9
    }

    /**
    Creates a CATextLayer and configures its properties, then adds the layer as a sublayer to the view
    
    Uses the following local variables:
        textLayer - A constant CATextLayer to create and add to the graph.
    
    :param: text A string that is the text to add to the graph.
    :param: xCoord A CGFloat that is the x coordinate of the location to draw the text
    :param: yCoord A CGFloat that is the y coordinate of the location to draw the text
    */
    func addTextToGraph(text: String, xCoord: CGFloat, yCoord: CGFloat) {
        let textLayer = CATextLayer()
        textLayer.string = text
        textLayer.fontSize = 10
        textLayer.font = UIFont.systemFont(ofSize: 10)
        textLayer.foregroundColor = UIColor.black.cgColor
        textLayer.frame = CGRect.init(x: xCoord, y: yCoord, width: 100, height: 12)
        textLayer.contentsScale = UIScreen.main.scale
        self.layer.addSublayer(textLayer)
    }

    /**
    Creates a CATextLayer and configures its properties, then adds the layer as a sublayer to the view.
    Unlike the addTextToGraph method this method rotates the text pi/2 radians so that it is vertical.
    
    Uses the following local variables:
        textLayer - A constant CATextLayer to create and add to the graph.
    
    :param: text A string that is the text to add to the graph.
    :param: xCoord A CGFloat that is the x coordinate of the location to draw the text
    :param: yCoord A CGFloat that is the y coordinate of the location to draw the text
    */
    func addXAxisTextToGraph(text: String, xCoord: CGFloat, yCoord: CGFloat) {
        let textLayer = CATextLayer()
        textLayer.string = text
        textLayer.fontSize = 10
        textLayer.font = UIFont.systemFont(ofSize: 10)
        textLayer.foregroundColor = UIColor.black.cgColor
        textLayer.frame = CGRect.init(x: xCoord, y: yCoord, width: 100, height: 12)
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.transform = CATransform3DMakeAffineTransform(CGAffineTransform(rotationAngle: CGFloat(Double.pi/2)))
        textLayer.position = CGPoint.init(x: xCoord, y: yCoord)
        self.layer.addSublayer(textLayer)
    }

    /**
    Creates the label for the yAxis as the markerNo * majorStep converted to a string

    Uses the following local variables:
        label - A constant string that is the text for the label.
    
    :param: markerNo An Integer value that is the number of the current marker.
    */
    func yAxisLabel(markerNo: Int) -> String {
        let label = "\(markerNo * Int(majorStep))"

        return label
    }
}
