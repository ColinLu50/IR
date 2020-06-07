#include <iostream>
#include <geometry_msgs/Twist.h>
#include <sensor_msgs/LaserScan.h>
#include <ros/ros.h>
#include <ros/console.h>
#include <image_transport/image_transport.h>
#include <cv_bridge/cv_bridge.h>
#include <sensor_msgs/image_encodings.h>
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <unistd.h>

using namespace std;


ros::Publisher cmdpub;
// ros::NodeHandle nh_;
// // image_transport::Subscriber image_sub_;
int static pokemon_num = 0;
bool catched = false;


void imageCb(const sensor_msgs::ImageConstPtr& msg)
{
    if(!catched) {
        cout<<"not catch" << endl;
        return;
    }
    printf("being in image call back\n");
    cv_bridge::CvImagePtr cv_ptr;
    try
    {
      cv_ptr = cv_bridge::toCvCopy(msg, sensor_msgs::image_encodings::BGR8);
    }
    catch (cv_bridge::Exception& e)
    {
      ROS_ERROR("cv_bridge exception: %s", e.what());
      return;
    }
    

   ROS_ASSERT( cv::imwrite( string( "pokemon" ) + string( ".png" ), cv_ptr->image ) );
   cout << "save image successfully" << endl;
   pokemon_num ++;
   exit(0);
   return;
};

void processLaserScan(const sensor_msgs::LaserScan::ConstPtr& scan)
{

    geometry_msgs::Twist twist = geometry_msgs::Twist();
    sleep(0.8);
    if(scan->ranges[360]>0.55){
	// cout<<"test"<<endl;
        twist.linear.x=0.1;
    }else if(scan->ranges[360]<0.5){
        twist.linear.x=-0.1;
    }else{
        twist.linear.x=0;
        
        if(pokemon_num == 0)
        {
            pokemon_num++;
            catched = true;
            sleep(2);
        }
    }

    // twist.linear.x=0.1;
    cmdpub.publish(twist);
    // cout << scan->ranges[360] << endl;
}
int main(int argc, char **argv)
{
    ros::init(argc, argv, "catch");
    ros::NodeHandle nd;
    ros::NodeHandle cmdh;   
    cmdpub = cmdh.advertise<geometry_msgs::Twist>("cmd_vel_mux/input/navi", 2);
    cout << "begin" << endl;
    ros::Subscriber scanSub = nd.subscribe<sensor_msgs::LaserScan>("scan", 10, processLaserScan);
    // ros::spin();
    ros::NodeHandle nh_;
    image_transport::ImageTransport it_(nh_);   
    cout<<"take pic"<<endl;
    ///pokemon_go/searcher
    image_transport::Subscriber imageSub = it_.subscribe("pokemon_go/searcher", 1, imageCb);
    cout<<"sub successfully"<<endl;
    ros::spin();

    return 0;
}
